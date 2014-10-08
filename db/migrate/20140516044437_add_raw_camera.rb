class AddRawCamera < ActiveRecord::Migration
  def change
    add_column :devices, :raw_camera_primary, :string
    add_column :devices, :raw_camera_features, :string
    add_column :devices, :raw_camera_video, :string
    add_column :devices, :raw_camera_secondary, :string
  end
end
