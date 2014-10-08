class CreateImageUrl < ActiveRecord::Migration
  def change
    create_table :image_urls do |t|
      add_column :devices, :image_url, :text
    end
  end
end
