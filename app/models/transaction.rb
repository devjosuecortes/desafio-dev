class Transaction < ApplicationRecord
  belongs_to :store

  validates_presence_of :transaction_type, :date, :value, :cpf, :card, :time, :store_id
end
