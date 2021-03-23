FactoryBot.define do
  factory :tag do
    name { Faker::Creature::Cat.registry }
    hexcolor { Faker::Color.hex_color }
  end
end
