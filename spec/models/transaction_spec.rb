require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:store) { create(:store) }

  # Validation tests with shoulda-matchers
  it { is_expected.to validate_presence_of(:transaction_type) }
  it { is_expected.to validate_presence_of(:date) }
  it { is_expected.to validate_presence_of(:value) }
  it { is_expected.to validate_presence_of(:cpf) }
  it { is_expected.to validate_presence_of(:card) }
  it { is_expected.to validate_presence_of(:time) }
  it { is_expected.to validate_presence_of(:store_id) }
  it { is_expected.to belong_to(:store) }

  context "when the transaction is valid" do
    it "creates a valid transaction" do
      transaction = create(:transaction, store: store)
      expect(transaction).to be_valid
    end
  end

  context "when the transaction is invalid" do
    it "is invalid without a transaction_type" do
      transaction = build(:transaction, transaction_type: nil, store: store)
      expect(transaction).not_to be_valid
    end

    it "is invalid without a date" do
      transaction = build(:transaction, date: nil, store: store)
      expect(transaction).not_to be_valid
    end

    it "is invalid without a value" do
      transaction = build(:transaction, value: nil, store: store)
      expect(transaction).not_to be_valid
    end

    it "is invalid without a cpf" do
      transaction = build(:transaction, cpf: nil, store: store)
      expect(transaction).not_to be_valid
    end

    it "is invalid without a card" do
      transaction = build(:transaction, card: nil, store: store)
      expect(transaction).not_to be_valid
    end

    it "is invalid without a time" do
      transaction = build(:transaction, time: nil, store: store)
      expect(transaction).not_to be_valid
    end

    it "is invalid without a store_id" do
      transaction = build(:transaction, store: nil)
      expect(transaction).not_to be_valid
    end
  end
end
