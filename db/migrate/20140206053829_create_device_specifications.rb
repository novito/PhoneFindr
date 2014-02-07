class CreateDeviceSpecifications < ActiveRecord::Migration
  def change
    create_table :device_specifications do |t|
      t.text :name
      t.text :value
      t.integer :device_page

      t.timestamps
    end
  end
end
