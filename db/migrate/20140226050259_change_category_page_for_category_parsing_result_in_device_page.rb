class ChangeCategoryPageForCategoryParsingResultInDevicePage < ActiveRecord::Migration
  def change
    rename_column :device_pages, :category_page_id, :category_parsing_result_id
  end
end
