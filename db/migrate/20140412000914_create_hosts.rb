class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.string :name
      t.text :description
      t.string :url
      t.references :institution, index: true

      t.timestamps
    end
  end
end
