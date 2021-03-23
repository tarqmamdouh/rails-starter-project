require 'faker'
FactoryBot.define do
  factory :answer do
    body { Faker::Lorem.question }
    question_id { FactoryBot.create(:question).id }
    user_id { FactoryBot.create(:user).id }
  end
end
