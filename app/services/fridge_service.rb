class FridgeService
  def initialize(fridge_params)
    @ingredients = fridge_params[:ingredients]
    @tags = fridge_params[:tags]
    @strict_ingredients = ActiveModel::Type::Boolean.new.
      cast(fridge_params.fetch(:strict_ingredients, false))
    @sort_method = fridge_params.fetch(:sort_method, :match_sort)
  end

  def call
    @relation = Recipe.all
    @relation = by_ingredients(@relation) if @ingredients.present?
    @relation = by_tags(@relation) if @tags.present?
    @relation = send(@sort_method, @relation)

    @relation
  end

  private

  def by_ingredients(relation)
    if @strict_ingredients
      strict_ingredients_query(relation)
    else
      relation.joins(:ingredients).where(
        Ingredient.arel_table[:name].matches_any(format_ingredients)
      )
    end
  end

  def count_sort(relation)
    relation.joins(:ingredients).group(Recipe.arel_table[:id]).order(Ingredient.arel_table[:id].count.desc)
  end

  def match_sort(relation)
    ir = IngredientsRecipe.arel_table
    recipes = Recipe.arel_table
    ir_alias = ir.alias("asd")

    ingredients_count = recipes
                          .join(ir.project(ir[:recipe_id], ir[:ingredient_id].count.as("ic"))
                                  .group(ir[:recipe_id]).as(ir_alias.name))
                          .on(ir_alias[:recipe_id].eq(recipes[:id]))

    relation.joins(:ingredients)
            .joins(ingredients_count.join_sources)
            .group(recipes[:id], ir_alias[:ic])
            .order((Ingredient.arel_table[:id].count * Arel::Nodes::SqlLiteral.new("100.0") / ir_alias[:ic]).desc)

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
