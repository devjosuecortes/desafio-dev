require 'rails_helper'

RSpec.describe CnabParserService, type: :service do
  let(:valid_cnab) { Rails.root.join('spec/fixtures/files/CNAB.txt') }
  let(:invalid_type_cnab) { Rails.root.join('spec/fixtures/files/CNAB_INVALID_TYPE.txt') }
  let(:invalid_date_cnab) { Rails.root.join('spec/fixtures/files/CNAB_INVALID_DATE.txt') }
  let(:invalid_cpf_cnab) { Rails.root.join('spec/fixtures/files/CNAB_INVALID_CPF.txt') }
  let(:invalid_value_cnab) { Rails.root.join('spec/fixtures/files/CNAB_INVALID_VALUE.txt') }
  let(:empty_cnab) { Rails.root.join('spec/fixtures/files/CNAB_EMPTY.txt') }
  let(:missing_valid_cnab) { Rails.root.join('spec/fixtures/files/MISSING_FILE.txt') }

  describe "#call" do
    context "when the file exists and contains valid transactions" do
      it "processes the file and creates transactions" do
        expect(File).to exist(valid_cnab), "O arquivo CNAB.txt não foi encontrado no caminho especificado."

        expect {
          CnabParserService.new(valid_cnab).call
        }.to change { Transaction.count }.by_at_least(21) # Ajuste conforme o número de transações no CNAB.txt

        transaction = Transaction.last
        expect(transaction).to be_present
        expect(transaction.store).to be_present
      end
    end

    context "when the file is missing" do
      it "logs an error" do
        expect(Rails.logger).to receive(:error).with(/\[CnabParserService\].*File not found/)

        result = CnabParserService.new(missing_valid_cnab).call

        expect(result).to be false
      end
    end

    context "when a line contains an invalid transaction type" do
      it "logs an error and rolls back transaction" do
        expect(Rails.logger).to receive(:error).with(/\[CnabParserService\].*Invalid transaction type/)

        result = CnabParserService.new(invalid_type_cnab).call

        expect(result).to be nil
      end
    end

    context "when a line contains an invalid date" do
      it "logs an error and rolls back transaction" do
        expect(Rails.logger).to receive(:error).with(/\[CnabParserService\].*Invalid date/)

        result = CnabParserService.new(invalid_date_cnab).call

        expect(result).to be nil
      end
    end

    context "when a line contains an invalid value" do
      it "log an error and rolls back transaction" do
        expect(Rails.logger).to receive(:error).with(/\[CnabParserService\].*Invalid data format/)

        result = CnabParserService.new(invalid_value_cnab).call

        expect(result).to be nil
      end
    end

    context "when a line contains an invalid CPF" do
      it "log an error and rolls back transaction" do
        expect(Rails.logger).to receive(:error).with(/\[CnabParserService\].*Invalid data format/)

        result = CnabParserService.new(invalid_cpf_cnab).call

        expect(result).to be nil
      end
    end

    context "when the file is empty" do
      it "log an error and return false" do
        expect(Rails.logger).to receive(:error).with(/\[CnabParserService\].*File is empty or contains no valid data/)

        result = CnabParserService.new(empty_cnab).call

        expect(result).to be false
      end
    end
  end
end
