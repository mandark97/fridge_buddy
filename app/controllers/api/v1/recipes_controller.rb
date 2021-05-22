class Api::V1::RecipesController < ApplicationController
  def index
    _pagy, recipes = pagy(Recipe.all.includes(:ingredients, :tags))

    render json: RecipeBlueprint.render(recipes)
  end

  def show
    recipe = Recipe.find(params[:id])

    render json: RecipeBlueprint.render(recipe, view: :extended)
  end

  def fridge
    recipes = FridgeService.new.call(fridge_params[:ingredients])

    render json: RecipeBlueprint.render(recipes, view: :extended)
  end

  private

  def fridge_params
    params.permit(ingredients: [])
  end
end
