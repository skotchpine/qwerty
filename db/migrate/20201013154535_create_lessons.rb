class CreateLessons < ActiveRecord::Migration[6.0]
  def change
    create_table :lessons do |t|
      t.integer :position
      t.string :title

      t.timestamps
    end
  end
end
