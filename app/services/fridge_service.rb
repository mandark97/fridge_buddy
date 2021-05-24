class FridgeService
  def initialize(fridge_params)
    @ingredients = fridge_params[:ingredients]
    @tags = fridge_params[:tags]
    @strict_ingredients = ActiveModel::Type::Boolean.new.
      cast(fridge_params.fetch(:strict_ingredients, false))
  end

  def call
    @relation = Recipe.all
    @relation = by_ingredients(@relation) if @ingredients.present?
    @relation = by_tags(@relation) if @tags.present?

    @relation
  end

  private

  def by_ingredients(relation)
    if @strict_ingredients
      strict_ingredients_query(relation)
    else
      relation.joins(:ingredients).where(
        Ingredient.arel_table[:name].matches_any(format_ingredients)
      ).distinct
    end
  end

  def strict_ingredients_query(relation)
    ingredient_recipes = IngredientsRecipe.arel_table
    ingredient = Ingredient.arel_table
    recipe = Recipe.arel_table

    recipes_with_other_ingredients = ingredient_recipes.
      join(ingredient).on(ingredient_recipes[:ingredient_id].eq(ingredient[:id])).
      project(ingredient_recipes[:recipe_id]).
      where(ingredient[:name].does_not_match_all(format_ingredients))
    recipes_with_ingredients = ingredient_recipes.
      join(ingredient).on(ingredient_recipes[:ingredient_id].eq(ingredient[:id])).
      project(ingredient_recipes[:recipe_id]).
      where(ingredient[:name].matches_any(format_ingredients))

    relation.where(recipe[:id].in(
      recipes_with_ingredients.except(recipes_with_other_ingredients)
    ))
  end

  def by_tags(relation)
    relation.joins(:tags).where(
      Gutentag::Tag.arel_table[:name].matches_all(@tags)
    )
  end

  def format_ingredients
    @ingredients.reject(&:blank?).map { |i| "%#{i}%" }
  end
end
