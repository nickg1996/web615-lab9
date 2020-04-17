
FactoryBot.define do
  factory :article do
    sequence(:title) { |n| "title_#{n}" }
    # uuid{"Article-#{SecureRandom.uuid}"}
    # slug{:uuid}

    content { 'This is my content' }
    user
  end
end