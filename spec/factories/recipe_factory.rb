FactoryBot.define do
  factory :recipe do
    name { Faker::Food.dish }
    author { Faker::Name.name }
    difficulty { Recipe.difficulties.keys.sample }
    budget { Recipe.budgets.keys.sample }
  end
end
