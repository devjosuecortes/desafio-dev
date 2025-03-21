class CreateStoreOwners < ActiveRecord::Migration[8.0]
  def change
    create_table :store_owners do |t|
      t.string :name

      t.timestamps
    end
  end
end
