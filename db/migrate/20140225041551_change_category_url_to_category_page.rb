class ChangeCategoryUrlToCategoryPage < ActiveRecord::Migration
  def change
    rename_table :category_urls, :category_pages
  end
end
