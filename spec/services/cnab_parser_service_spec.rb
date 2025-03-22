require 'rails_helper'

RSpec.describe CnabParserService, type: :service do
  let(:valid_cnab) { Rails.root.join('spec/fixtures/files/CNAB.txt') }
  let(:invalid_type_cnab) { Rails.root.join('spec/fixtures/files/CNAB_INVALID_TYPE.txt') }
  let(:invalid_date_cnab) { Rails.root.join('spec/fixtures/files/CNAB_INVALID_DATE.txt') }
  let(:invalid_cpf_cnab) { Rails.root.join('spec/fixtures/files/CNAB_INVALID_CPF.txt') }
  let(:invalid_value_cnab) { Rails.root.join('spec/fixtures/files/CNAB_INVALID_VALUE.txt') }
  let(:empty_cnab) { Rails.root.join('spec/fixtures/files/CNAB_EMPTY.txt') }
  let(:missing_cnab) { Rails.root.join('spec/fixtures/files/MISSING_FILE.txt') }

  describe "#call" do
    context "when the file exists and contains valid transactions" do
      it "processes the file and creates transactions" do
        expect(File).to exist(valid_cnab), "O arquivo CNAB.txt não foi encontrado no caminho especificado."

        expect {
          CnabParserService.new(valid_cnab).call
        }.to change { Transaction.count }.by_at_least(21)

        transaction = Transaction.last
        expect(transaction).to be_present
        expect(transaction.store).to be_present
      end
    end

    context "when the file is missing" do
      it "return false with errors" do
        result = CnabParserService.new(missing_cnab).call
        expect(result[:success]).to be false
        expect(result[:errors]).to include("File is empty or contains no valid data")
      end
    end

    context "when a line contains an invalid transaction type" do
      it "return false with errors and rollback transactions" do
        result = CnabParserService.new(invalid_type_cnab).call
        expect(result[:success]).to be false
        expect(result[:errors]).to include("Invalid data format: Line 7 is invalid: Invalid transaction type '0'")
        expect(Transaction.count).to eq(0)
      end
    end

    context "when a line contains an invalid date" do
      it "return false with errors and rollback transactions" do
        result = CnabParserService.new(invalid_date_cnab).call
        expect(result[:success]).to be false
        expect(result[:errors]).to include("Invalid data format: Line 3 is invalid: Invalid date '20190334'")
        expect(Transaction.count).to eq(0)
      end
    end

    context "when a line contains an invalid value" do
      it "return false with errors and rollback transactions" do
        result = CnabParserService.new(invalid_value_cnab).call
        expect(result[:success]).to be false
        expect(result[:errors]).to include("Invalid data format: Line 2 is invalid: Invalid value '0X00014200'")
        expect(Transaction.count).to eq(0)
      end
    end

    context "when a line contains an invalid CPF" do
      it "return false with errors and rollback transactions" do
        result = CnabParserService.new(invalid_cpf_cnab).call
        expect(result[:success]).to be false
        expect(result[:errors]).to include("Invalid data format: Line 2 is invalid: Invalid card '475*****3153'")
        expect(Transaction.count).to eq(0)
      end
    end

    context "when the file is empty" do
      it "return false with errors and rollback transactions" do
        result = CnabParserService.new(empty_cnab).call
        expect(result[:success]).to be false
        expect(result[:errors]).to include("File is empty or contains no valid data")
        expect(Transaction.count).to eq(0)
      end
    end
  end
end
