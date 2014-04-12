class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :res_code
      t.string :res_message
      t.decimal :res_time
      t.string :status
      t.string :status_message

      t.references :layer, index: true

      t.timestamps
    end
  end
end
