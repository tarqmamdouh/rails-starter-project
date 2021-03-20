FactoryBot.define do
  factory :user do
    password { "password" }
    sequence :email do |n|n
    "user_#{n}@example.com"
    end
  end
end