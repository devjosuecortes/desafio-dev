FactoryBot.define do
  factory :store do
    sequence(:name) { |n| "Store #{n}" }
    association :store_owner
  end
end
