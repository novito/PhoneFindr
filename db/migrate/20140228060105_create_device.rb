class CreateDevice < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.integer :device_page_id
      t.string :picture_url
      t.datetime :date
      t.boolean :available
      t.text :operating_system
      t.string :name

      t.timestamps
    end
  end
end
