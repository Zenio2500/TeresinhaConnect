class CreatePastorals < ActiveRecord::Migration[8.0]
  def change
    create_table :pastorals do |t|
      t.string :name, null: false
      t.references :coordinator, null: false, foreign_key: { to_table: :users }
      t.references :vice_coordinator, null: false, foreign_key: { to_table: :users }
      t.string :description
      
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :pastorals, :deleted_at
    add_index :pastorals, :name, unique: true
  end
end
