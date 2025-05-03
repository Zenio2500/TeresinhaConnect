class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password, null: false
      t.boolean :is_coordinator, default: false

      t.datetime :deleted_at
      t.timestamps
    end
    add_index :users, :deleted_at
    add_index :users, :email, unique: true
  end
end
