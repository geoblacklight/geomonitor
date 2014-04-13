class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :res_code
      t.string :res_message
      t.decimal :res_time
      t.string :status
      t.text :status_message
      t.text :submitted_query
      t.boolean :latest

      t.references :layer, index: true

      t.timestamps
    end
  end
end
