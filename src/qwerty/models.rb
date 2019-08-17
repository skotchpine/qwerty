#
# Models
#
class User < Sequel::Model
  one_to_many :submissions
  plugin :secure_password
end

class Lesson < Sequel::Model
  one_to_many :exercises
end

Lesson.dataset_module { order :position }

class Exercise < Sequel::Model
  many_to_one :lesson
  one_to_many :submissions
end

Exercise.dataset_module { order :position }

class Submission < Sequel::Model
  many_to_one :exercise
  many_to_one :user
end