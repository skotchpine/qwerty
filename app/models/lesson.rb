class Lesson < ApplicationRecord
  has_many :exercises

  validates_presence_of :title
  validates_presence_of :position
end
