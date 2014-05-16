class AddRawSoundLoudspeaker < ActiveRecord::Migration
  def change
    add_column :devices, :raw_sound_loudspeaker, :string
  end
end
