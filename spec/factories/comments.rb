FactoryBot.define do
  factory :comment do
    commenter Faker::Simpsons.character
    body Faker::Simpsons.quote
    article { build(:article) }
    human true
  end

  factory :comment_without_article, parent: :comment do |c|
    c.article nil
  end

  factory :unaccepted_comment, parent: :comment do |c|
    c.human nil
  end
end
