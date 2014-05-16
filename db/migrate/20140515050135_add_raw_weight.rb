class AddRawWeight < ActiveRecord::Migration
  def change
    add_column :devices, :raw_weight, :string
  end
end
