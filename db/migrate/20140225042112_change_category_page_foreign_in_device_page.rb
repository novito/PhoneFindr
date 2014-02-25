class ChangeCategoryPageForeignInDevicePage < ActiveRecord::Migration
  def change
    rename_column :device_pages, :category_url_id, :category_page_id
  end
end
