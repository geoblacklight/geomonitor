class CreateInstitutions < ActiveRecord::Migration
  def change
    create_table :institutions do |t|
      t.string :name

      t.timestamps
    end
    add_index :institutions, :name, unique: true
  end
end
