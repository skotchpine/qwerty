FactoryBot.define do
  factory :user do
    sequence(:email) { "test-#{_1}@sample.com" }
    password { 'asdfasdf' }
  end
end