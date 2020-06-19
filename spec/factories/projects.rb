FactoryBot.define do
  factory :project do
    title { Faker::Creature::Animal.unique.name }
  end
end
