class FridgeService
  def initialize
  end

  def call(ingredients)
    Recipe.joins(:ingredients).where(match_any(ingredients))
  end

  private

  def match_any(ingredients)
    ingredient_table[:name].matches_any(format_ingredients(ingredients))
  end

  def match_all(ingredients)
    ingredient_table[:name].matches_any(format_ingredients(ingredients))
  end

  def ingredient_table
    @ingredient_table ||= Ingredient.arel_table
  end

  def format_ingredients(ingredients)
    ingredients.map { |i| "%#{i}%" }
  end
end
