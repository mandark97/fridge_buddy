require 'rails_helper'

RSpec.describe "Recipes", type: :request do
  describe "GET /api/v1/recipes" do
    let!(:recipes) { FactoryBot.create_list(:recipe, 5) }

    it "returns recipes" do
      get "/api/v1/recipes"

      expect(response.status).to eq(200)
      expect(parsed_response["recipes"].size).to eq(5)
    end
  end

  describe "GET /api/v1/recipes/:id" do
    let(:recipe) { FactoryBot.create(:recipe) }

    it "returns one recipe" do
      get "/api/v1/recipes/#{recipe.id}"

      expect(response.status).to eq(200)
      expect(parsed_response["id"]).to eq(recipe.id)
    end
  end
end
