class Exercise < ApplicationRecord
  belongs_to :lesson

  validates_presence_of :position, :title, :content, :min_wpm, :fast_wpm, :max_typos
  validates :position, :min_wpm, :fast_wpm, :max_typos, numericality: { greater_than: -1 }
end
