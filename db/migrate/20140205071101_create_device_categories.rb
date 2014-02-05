class CreateDeviceCategories < ActiveRecord::Migration
  def change
    create_table :device_categories do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
