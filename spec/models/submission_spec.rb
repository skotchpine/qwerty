require 'rails_helper'

RSpec.describe Submission, type: :model do
  let :lesson do
    Lesson.create(title: 'test lesson', position: 0)
  end

  let :exercise do
    Exercise.create \
      lesson: lesson,
      title: 'test exercise',
      position: 0,
      content: 'adsf asdf asdf',
      min_wpm: 0,
      fast_wpm: 0,
      max_typos: 0
  end

  let :user do
    User.create(email: 'test@test.test', password: 'testytest')
  end

  let :new_submission do
    Submission.new \
      exercise: exercise,
      user: user,
      right: 0,
      wrong: 0,
      accuracy: 0,
      wpm: 0,
      complete: false,
      accurate: false,
      fast: false
  end

  it 'belongs to a exercise' do
    t = Submission.reflect_on_association(:exercise)
    expect(t.macro).to eq(:belongs_to)
  end

  it 'belongs to a user' do
    t = Submission.reflect_on_association(:user)
    expect(t.macro).to eq(:belongs_to)
  end

  it 'is valid with valid attributes' do
    expect(new_submission).to be_valid
  end

  %w[
    right
    wrong
    accuracy
    wpm
    complete
    accurate
    fast
  ]
    .each do |field|
      it "is not valid without a #{field}" do
        new_submission.send("#{field}=", nil)
        expect(new_submission).to_not be_valid
      end
    end

  %w[
    right
    wrong
    accuracy
    wpm
  ]
    .each do |field|
      it "is not valid without #{field} < 0" do
        new_submission.send("#{field}=", -1)
        expect(new_submission).to_not be_valid
      end
    end
end
