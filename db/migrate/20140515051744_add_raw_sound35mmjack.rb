class AddRawSound35mmjack < ActiveRecord::Migration
  def change
    add_column :devices, :raw_sound_35_mm_jack, :string
  end
end
