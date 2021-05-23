FactoryBot.define do
  factory :ingredient do
    name { "#{Faker::Food.measurement} #{Faker::Food.ingredient}" }
  end
end
