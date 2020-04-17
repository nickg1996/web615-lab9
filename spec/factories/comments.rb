FactoryBot.define do
  factory :comment do
    sequence(:message) { |n| "comment_#{n}" }
    # uuid{"Comment-#{SecureRandom.uuid}"}
    # slug{:uuid}
    article
    user
  end
end
