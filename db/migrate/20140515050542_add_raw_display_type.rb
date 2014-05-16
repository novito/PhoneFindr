class AddRawDisplayType < ActiveRecord::Migration
  def change
    add_column :devices, :raw_display_type, :string
  end
end
