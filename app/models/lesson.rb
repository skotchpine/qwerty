class Lesson < ApplicationRecord
  has_many :exercises

  validates_presence_of :title
  validates_presence_of :position
  %i[complete accurate fast].each do |m|
    define_method m do |user_id|
      return false unless exercises.any?
      ret=true
      exercises.each do |exercise|
        unless exercise.send(m,user_id)
          ret=false
          break
        end
      end
      ret
    end
  end
  Lesson.order(:ordered,:position)
end
