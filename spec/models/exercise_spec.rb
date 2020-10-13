require 'rails_helper'

RSpec.describe Exercise, type: :model do
  let :lesson do
    Lesson.create(title: 'test lesson', position: 0)
  end

  let :new_exercise do
    Exercise.new \
      lesson: lesson,
      title: 'test exercise',
      position: 0,
      content: 'adsf asdf asdf',
      min_wpm: 0,
      fast_wpm: 0,
      max_typos: 0
  end

  it 'belongs to a lesson' do
    t = Exercise.reflect_on_association(:lesson)
    expect(t.macro).to eq(:belongs_to)
  end

  it 'is valid with valid attributes' do
    expect(new_exercise).to be_valid
  end

  %w[
    position
    title
    content
    min_wpm
    fast_wpm
    max_typos
  ]
    .each do |field|
      it "is not valid without a #{field}" do
        new_exercise.send("#{field}=", nil)
        expect(new_exercise).to_not be_valid
      end
    end

  %w[
    position
    min_wpm
    fast_wpm
    max_typos
  ]
    .each do |field|
      it "is not valid without #{field} < 0" do
        new_exercise.send("#{field}=", -1)
        expect(new_exercise).to_not be_valid
      end
    end
end
