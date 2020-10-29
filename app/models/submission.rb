class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :exercise

  validates_inclusion_of :complete, :accurate, :fast, in: [true, false]
  validates :right, :wrong, :accuracy, :wpm,
    presence: true,
    numericality: { greater_than: -1 }

  def self.from_results(user_id,exercise_id,right,wrong,accuracy,wpm)
    exercise=Exercise.where(id: user_id).first
    complete = wrong <= exercise.max_typos && wpm >= exercse.min_wpm
    accurate = complete && wrong.zero?

    create \
     user_id: user_id,
     exercise_id: exercise_id,

     right: right,
     wrong: wrong,
     accuracy: accuracy,
     wpm: wpm,
     
     complete: complete,
     accurate: accurate,
     fast: fast,

     created_at: DateTime.now
  end



end
