class CreateGrades < ActiveRecord::Migration[8.0]
  def change
    create_table :grades do |t|
      t.datetime :date
      t.boolean :is_solemnity, default: false
      t.string :liturgical_color
      t.string :liturgical_time
      t.string :description
      
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :grades, :deleted_at
  end
end
