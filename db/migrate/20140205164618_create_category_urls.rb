class CreateCategoryUrls < ActiveRecord::Migration
  def change
    create_table :category_urls do |t|
      t.integer :source_id
      t.datetime :last_parsed
      t.string :url

      t.timestamps
    end
  end
end
