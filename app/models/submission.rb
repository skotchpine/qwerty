class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :exercise

  validates_inclusion_of :complete, :accurate, :fast, in: [true, false]
  validates :right, :wrong, :accuracy, :wpm,
    presence: true,
    numericality: { greater_than: -1 }
end
