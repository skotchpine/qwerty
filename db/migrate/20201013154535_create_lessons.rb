class CreateLessons < ActiveRecord::Migration[6.0]
  def change
    create_table :lessons do |t|
      t.integer :position, null: false
      t.string :title, null: false

      t.timestamps
    end
  end
end
