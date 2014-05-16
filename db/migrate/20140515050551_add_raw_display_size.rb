class AddRawDisplaySize < ActiveRecord::Migration
  def change
    add_column :devices, :raw_display_size, :string
  end
end
