class AddSlugToLayers < ActiveRecord::Migration
  def change
    add_column :layers, :slug, :string, unique: true
  end
end
