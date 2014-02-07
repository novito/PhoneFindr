class CreateDevicePages < ActiveRecord::Migration
  def change
    create_table :device_pages do |t|
      t.string :url
      t.datetime :last_parsed
      t.integer :category_url_id

      t.timestamps
    end
  end
end
