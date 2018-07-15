FactoryBot.define do
  factory :article do
    title 'title 1'
    text 'description'
    city 'New York'
    state 'NY'
  end

  factory :invalid_article, parent: :article do |a|
    a.title nil
  end

  factory :user do
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'
  end
end
