class AddRawFeaturesAndRawBattery < ActiveRecord::Migration
  def change
    add_column :devices, :raw_features_chipset, :string
    add_column :devices, :raw_features_cpu, :string
    add_column :devices, :raw_features_gpu, :string
    add_column :devices, :raw_features_sensors, :string
    add_column :devices, :raw_features_messaging, :string
    add_column :devices, :raw_features_browser, :string
    add_column :devices, :raw_features_radio, :string
    add_column :devices, :raw_features_gps, :string
    add_column :devices, :raw_features_java, :string
    add_column :devices, :raw_features_colors, :string
    add_column :devices, :raw_battery_standby, :string
    add_column :devices, :raw_battery_talk_time, :string
    add_column :devices, :raw_battery_music_play, :string
  end
end
