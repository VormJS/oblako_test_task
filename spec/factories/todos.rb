FactoryBot.define do
  factory :todo do
    text { Faker::Creature::Animal.name }
    isCompleted { [true, false].sample }
    project { nil }
  end
end
