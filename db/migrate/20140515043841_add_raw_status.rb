class AddRawStatus < ActiveRecord::Migration
  def change
    add_column :devices, :raw_status, :string
  end
end
