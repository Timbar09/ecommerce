class DropAdminsTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :admins, if_exists: true
  end
end
