class AddBrandIdToCategoryPages < ActiveRecord::Migration
  def change
    add_column :category_pages, :brand_id, :integer
  end
end
