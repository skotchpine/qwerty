#
# Models
#
class User < Sequel::Model
  one_to_many :submissions
  plugin :secure_password
end

class Lesson < Sequel::Model
  one_to_many :exercises

  %i[complete accurate fast].each do |m|
    define_method m do |user_id|
      return false unless exercises.any?
      
      ret = true

      exercises.each do |exercise|
        unless exercise.send(m, user_id)
          ret = false
          break
        end
      end

      ret
    end
  end
end

Lesson.dataset_module { order :position }

class Exercise < Sequel::Model
  many_to_one :lesson
  one_to_many :submissions

  %i[complete accurate fast].each do |m|
    define_method m do |user_id|
      submissions.any? do |submission|
        submission.user_id == user_id and submission.send(m)
      end
    end
  end
end

Exercise.dataset_module { order :position }

class Submission < Sequel::Model
  many_to_one :exercise
  many_to_one :user
end