class CreateUserPastorals < ActiveRecord::Migration[8.0]
  def change
    create_table :user_pastorals do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.references :pastoral, null: false, foreign_key: { to_table: :pastorals }
      
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :user_pastorals, :deleted_at
  end
end
