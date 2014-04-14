class CreatePings < ActiveRecord::Migration
  def change
    create_table :pings do |t|
      t.boolean :status
      t.boolean :latest
      t.references :host, index: true

      t.timestamps
    end
  end
end
