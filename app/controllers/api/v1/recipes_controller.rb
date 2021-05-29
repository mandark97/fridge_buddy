class Api::V1::RecipesController < ApplicationController
  def show
    recipe = Recipe.find(params[:id])

    render json: RecipeBlueprint.render(recipe, view: :extended)
  end

  def index
    recipes = FridgeService.new(fridge_params).call
    pagy, results = pagy(recipes)

    render json: RecipeBlueprint.render(results, root: :recipes,
                                                 meta: pagination_meta(pagy))
  end

  private

  def fridge_params
    params.permit(:page, :strict_ingredients, :sort_method, ingredients: [])
  end
end
