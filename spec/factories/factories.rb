FactoryBot.define do
  factory :user do
    sequence(:email) { "test-#{_4}@sample.com" }
    password { 'asdfasdf' }
  end
end
