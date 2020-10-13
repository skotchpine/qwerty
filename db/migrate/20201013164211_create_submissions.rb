class CreateSubmissions < ActiveRecord::Migration[6.0]
  def change
    create_table :submissions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true
      t.integer :right, null: false
      t.integer :wrong, null: false
      t.integer :accuracy, null: false
      t.integer :wpm, null: false
      t.boolean :complete, null: false
      t.boolean :accurate, null: false
      t.boolean :fast, null: false

      t.timestamps
    end
  end
end
