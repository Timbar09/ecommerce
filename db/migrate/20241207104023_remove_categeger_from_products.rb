class RemoveCategegerFromProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :categeger, :string
  end
end
