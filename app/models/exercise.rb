class Exercise < ApplicationRecord
  belongs_to :lesson
  has_many :submissions

  validates_presence_of :position, :title, :content, :min_wpm, :fast_wpm, :max_typos
  validates :position, :min_wpm, :fast_wpm, :max_typos, numericality: { greater_than: -1 }
  
  %i[complete accurate fast].each do |m|
    define method m do |user_id|
      submissions.any? do |submission|
        subission.user_id = user_id and submission.send(m)
      end
    end
  end
  Exercise.order(:ordered,:position)
end
