class AddRawPrice < ActiveRecord::Migration
  def change
      add_column :devices, :raw_price, :string
  end
end
