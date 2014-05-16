class AddRawDimensions < ActiveRecord::Migration
  def change
    add_column :devices, :raw_dimensions, :string
  end
end
