class AddActiveFlagToLayers < ActiveRecord::Migration
  def change
    add_column :layers, :active, :boolean
  end
end
