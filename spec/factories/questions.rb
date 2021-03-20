FactoryBot.define do
  factory :question do
    title { "title" }
    description { "description" }
    user_id { FactoryBot.create(:user).id }
    sequence(:slug) { |_n| "slug-#{(0...10).map { ('a'..'z').to_a[rand(26)] }.join}" }
  end
end