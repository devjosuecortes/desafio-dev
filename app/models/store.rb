class Store < ApplicationRecord
  belongs_to :store_owner
  has_many :transactions

  validates_presence_of :name, :store_owner_id
  validates_uniqueness_of :name, scope: :store_owner_id
end
