class AddRawSoundAlertTypes < ActiveRecord::Migration
  def change
    add_column :devices, :raw_sound_alert_types, :string
  end
end
