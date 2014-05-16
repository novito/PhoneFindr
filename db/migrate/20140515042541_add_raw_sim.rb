class AddRawSim < ActiveRecord::Migration
  def change
    add_column :devices, :raw_sim, :string
  end
end
