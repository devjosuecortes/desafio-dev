require 'rails_helper'

RSpec.describe Store, type: :model do
  let(:store_owner) { create(:store_owner) }

  subject { build(:store, store_owner: store_owner) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:store_owner_id) }

  it "validates uniqueness of name scoped to store_owner_id" do
    expect(subject).to validate_uniqueness_of(:name).scoped_to(:store_owner_id)
  end

  it { is_expected.to belong_to(:store_owner) }

  it "creates a valid store" do
    store = create(:store, store_owner: store_owner)
    expect(store).to be_valid
  end

  it "does not allow stores with the same name for the same owner" do
    create(:store, name: "Test Store", store_owner: store_owner)
    duplicate_store = build(:store, name: "Test Store", store_owner: store_owner)

    expect(duplicate_store).not_to be_valid
  end

  it "allows stores with the same name for different owners" do
    other_owner = create(:store_owner, name: "Another Owner")
    create(:store, name: "Common Store", store_owner: store_owner)
    store2 = build(:store, name: "Common Store", store_owner: other_owner)

    expect(store2).to be_valid
  end
end
