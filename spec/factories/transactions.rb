FactoryBot.define do
  factory :transaction do
    association :store
    transaction_type { rand(1..9) }
    date { Faker::Date.backward(days: 30).strftime('%Y-%m-%d') }
    value { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    cpf { Faker::Number.number(digits: 11) }
    card { Faker::Finance.credit_card }
    time { Faker::Time.backward(days: 30, period: :morning) }
  end
end
