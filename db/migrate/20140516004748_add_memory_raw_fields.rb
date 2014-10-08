class AddMemoryRawFields < ActiveRecord::Migration
  def change
    add_column :devices, :raw_memory_internal, :string
    add_column :devices, :raw_memory_card_slot, :string
  end
end
