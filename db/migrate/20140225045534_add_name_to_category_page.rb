class AddNameToCategoryPage < ActiveRecord::Migration
  def change
    add_column :category_pages, :name, :string
  end
end
