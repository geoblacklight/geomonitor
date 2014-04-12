class CreateLayers < ActiveRecord::Migration
  def change
    create_table :layers do |t|
      t.string :name
      t.text :description
      t.references :host, index: true

      t.timestamps
    end
  end
end
