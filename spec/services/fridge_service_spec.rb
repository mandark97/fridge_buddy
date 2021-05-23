require 'rails_helper'

RSpec.describe FridgeService do
  describe "#call" do
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

    it "returns recipes with any of the ingredients" do
      params = {
        strategy: "matches_any",
        ingredients: ["cheese"],
      }
      subject = FridgeService.new(params)
      response = subject.call
      expect(response.size).to eq(3)
      expect(response).to include(ham_cheese_bread)
      expect(response).to include(cheese_bread)
      expect(response).to include(milk_cheese)
    end

    it "works when multiple ingredients are searched" do
      params = {
        strategy: "matches_any",
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
end
