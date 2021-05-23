FactoryBot.define do
  factory :tag do
    name { Faker::Food.ingredient }
  end
end
