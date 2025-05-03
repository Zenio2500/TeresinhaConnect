class CreateReaderGrades < ActiveRecord::Migration[8.0]
  def change
    create_table :reader_grades do |t|
      t.references :reader, null: false, foreign_key: { to_table: :readers }
      t.references :grade, null: false, foreign_key: { to_table: :grades }

      t.datetime :deleted_at
      t.timestamps
    end
    add_index :reader_grades, :deleted_at
  end
end
