class CreateAdminStocks < ActiveRecord::Migration[8.0]
  def change
    create_table :stocks do |t|
      t.integer :size
      t.integer :quantity
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
