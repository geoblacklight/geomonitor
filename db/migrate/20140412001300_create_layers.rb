class CreateLayers < ActiveRecord::Migration
  def change
    create_table :layers do |t|
      t.string :name
      t.string :geoserver_layername
      t.string :access
      t.text :description
      t.string :bbox
      t.references :host, index: true
      t.integer :statuses_count

      t.timestamps
    end
  end
end
