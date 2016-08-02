class CreateEndpoints < ActiveRecord::Migration
  def change
    create_table :endpoints do |t|
      t.string :name
      t.string :url
      t.references :host
      t.timestamps null: false
    end
  end
end
