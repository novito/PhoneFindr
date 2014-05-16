class AddRawNetworks < ActiveRecord::Migration
  def change
    add_column :devices, :raw_network_2g, :string
    add_column :devices, :raw_network_3g, :string
    add_column :devices, :raw_network_4g, :string
  end
end
