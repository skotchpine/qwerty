require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has many submissions' do
    t = User.reflect_on_association(:submissions)
    expect(t.macro).to eq(:has_many)
  end
end