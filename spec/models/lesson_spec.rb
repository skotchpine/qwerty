require 'rails_helper'

RSpec.describe Lesson, type: :model do
  let :new_lesson do
    Lesson.new(title: 'test title', position: 0)
  end

  it 'is valid with valid attributes' do
    expect(new_lesson).to be_valid
  end

  it 'is not valid without a title' do
    new_lesson.title = nil
    expect(new_lesson).to_not be_valid
  end

  it 'is not valid without a position' do
    new_lesson.position = nil
    expect(new_lesson).to_not be_valid
  end
end
