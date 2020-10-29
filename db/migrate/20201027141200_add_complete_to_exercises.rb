class AddCompleteToExercises < ActiveRecord::Migration[6.0]
  def change
    add_column :exercises, :complete, :boolean
  end
end
