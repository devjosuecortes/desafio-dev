class CreateStores < ActiveRecord::Migration[8.0]
  def change
    create_table :stores do |t|
      t.string :name
      t.references :store_owner, null: false, foreign_key: true

      t.timestamps
    end
  end
end
