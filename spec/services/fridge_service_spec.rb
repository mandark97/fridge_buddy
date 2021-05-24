require 'rails_helper'

RSpec.describe FridgeService do
  let(:ham) { FactoryBot.create(:ingredient, name: "ham") }
  let(:cheese) { FactoryBot.create(:ingredient, name: "cheese") }
  let(:bread) { FactoryBot.create(:ingredient, name: "bread") }
  let(:milk) { FactoryBot.create(:ingredient, name: "milk") }
  let(:potato) { FactoryBot.create(:ingredient, name: "potato") }

  let!(:ham_cheese_bread) do
    FactoryBot.create(:recipe, name: "ham&cheese sandwich",
                               ingredients: [ham, cheese, bread])
  end
  let!(:cheese_bread) do
    FactoryBot.create(:recipe, name: "cheese sandwich",
                               ingredients: [cheese, bread])
  end
  let!(:milk_cheese) do
    FactoryBot.create(:recipe, name: "milk & cheese??",
                               ingredients: [milk, cheese])
  end
  let!(:milk_bread) do
    FactoryBot.create(:recipe, name: "milk & bread",
                               ingredients: [milk, bread])
  end
  let!(:potato_bread) do
    FactoryBot.create(:recipe, name: "potato & bread",
                               ingredients: [potato, bread])
  end

  context "strict_ingredients false" do
    it "returns recipes with any of the ingredients" do
      params = {
        strict_ingredients: false,
        ingredients: ["bread"],
      }
      subject = FridgeService.new(params)
      response = subject.call

      expect(response.size).to eq(4)
      expect(response).to include(ham_cheese_bread)
      expect(response).to include(cheese_bread)
      expect(response).to include(potato_bread)
      expect(response).to include(milk_bread)
    end

    it "works when multiple ingredients are searched" do
      params = {
        ingredients: ["cheese", "potato"],
      }
      subject = FridgeService.new(params)
      response = subject.call

      expect(response.size).to eq(4)
      expect(response).to include(ham_cheese_bread)
      expect(response).to include(cheese_bread)
      expect(response).to include(milk_cheese)
      expect(response).to include(potato_bread)
    end
  end

  context "strict_ingredients" do
    it "returns recipes only with the specified ingredients" do
      params = {
        strict_ingredients: true,
        ingredients: ["cheese", "bread", "ham", "milk"],
      }
      subject = FridgeService.new(params)
      response = subject.call

      expect(response.size).to eq(4)
      expect(response).to include(ham_cheese_bread)
      expect(response).to include(cheese_bread)
      expect(response).to include(milk_bread)
      expect(response).to include(milk_cheese)
    end

    it "returns nothing if not enough ingredients" do
      params = {
        strict_ingredients: true,
        ingredients: ["cheese"],
      }
      subject = FridgeService.new(params)
      response = subject.call

      expect(response.size).to eq(0)
    end
  end
end
