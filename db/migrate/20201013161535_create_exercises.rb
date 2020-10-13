class CreateExercises < ActiveRecord::Migration[6.0]
  def change
    create_table :exercises do |t|
      t.references :lesson, null: false, foreign_key: true
      t.integer :position, null: false
      t.string :content, null: false
      t.string :title, null: false
      t.integer :max_typos, null: false
      t.integer :min_wpm, null: false
      t.integer :fast_wpm, null: false

      t.timestamps
    end
  end
end
