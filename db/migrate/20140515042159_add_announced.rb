class AddAnnounced < ActiveRecord::Migration
  def change
    add_column :devices, :announced, :string
  end
end
