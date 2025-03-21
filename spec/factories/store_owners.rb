FactoryBot.define do
  factory :store_owner do
    sequence(:name) { |n| "Jon Doe #{n}" }
  end
end
