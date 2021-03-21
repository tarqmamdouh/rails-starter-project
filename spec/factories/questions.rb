require 'faker'

FactoryBot.define do
  factory :question do
    title { Faker::Lorem.question }
    description { Faker::Lorem.paragraph(sentence_count: 2, supplemental: false, random_sentences_to_add: 4) }
    user_id { FactoryBot.create(:user).id }
    tags_string { Faker::Creature::Cat.registry }
  end
end