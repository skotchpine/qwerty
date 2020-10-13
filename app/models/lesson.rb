class Lesson < ApplicationRecord
  validates_presence_of :title
  validates_presence_of :position
end
