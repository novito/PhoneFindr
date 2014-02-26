class CategoryParsingResults < ActiveRecord::Migration
  def change
    create_table :category_parsing_results do |t|
      t.integer :category_page_id
      t.datetime :date

      t.timestamps
    end
  end
end
