class AddReaderTypeToReaderGrades < ActiveRecord::Migration[8.0]
  def change
    add_column :reader_grades, :reader_type, :string
  end
end
