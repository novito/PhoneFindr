class AddRawForData < ActiveRecord::Migration
  def change
    add_column :devices, :raw_data_gprs, :string
    add_column :devices, :raw_data_edge, :string
    add_column :devices, :raw_data_speed, :string
    add_column :devices, :raw_data_wlan, :string
    add_column :devices, :raw_data_bluetooth, :string
    add_column :devices, :raw_data_usb, :string
  end
end
