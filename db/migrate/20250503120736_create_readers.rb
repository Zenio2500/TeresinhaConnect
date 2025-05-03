class CreateReaders < ActiveRecord::Migration[8.0]
  def change
    create_table :readers do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.string :disponibility, array: true, default: []
      t.string :read_types, array: true, default: []

      t.datetime :deleted_at
      t.timestamps
    end
    add_index :readers, :deleted_at
  end
end
