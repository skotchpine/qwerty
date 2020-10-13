#
# USERS
#
unless database.table_exists?(:users)
  migration 'create users' do
    database.create_table :users do
      primary_key :id

      String :username
      String :password_digest

      timestamp :created_at
      timestamp :updated_at
    end
  end
end

#
# LESSONS
#
unless database.table_exists?(:lessons)
  migration 'create lessons' do
    database.create_table :lessons do
      primary_key :id

      Integer :position
      String :title
    end
  end
end

#
# EXERCISES
#
unless database.table_exists?(:exercises)
  migration 'create exercises' do
    database.create_table :exercises do
      primary_key :id
      foreign_key :lesson_id, :lessons, null: false

      Integer :position
      String :content
    end
  end
end

migration 'add criteria to exercises' do
  unless database[:exercises].columns.include?(:title)
    database.add_column :exercises, :title, String
    database.add_column :exercises, :max_typos, Integer
    database.add_column :exercises, :min_wpm, Integer
    database.add_column :exercises, :fast_wpm, Integer
  end
end

#
# SUBMISSIONS
#
unless database.table_exists?(:submissions)
  migration 'create submissions' do
    database.create_table :submissions do
      primary_key :id
      foreign_key :user_id,     :users,     null: false
      foreign_key :exercise_id, :exercises, null: false

      Integer :right,    null: false
      Integer :wrong,    null: false
      Integer :accuracy, null: false
      Integer :wpm,      null: false

      Boolean :complete, null: false
      Boolean :accurate, null: false
      Boolean :fast, null: false

      timestamp :created_at
    end
  end
end