class FridgeService
  def initialize(fridge_params)
    @ingredients = fridge_params[:ingredients]
    @tags = fridge_params[:tags]
  end

  def call
    @relation = Recipe.all
    @relation = by_ingredients(@relation) if @ingredients.present?
    @relation = by_tags(@relation) if @tags.present?

    @relation
  end

  private

  def by_ingredients(relation)
    relation.joins(:ingredients).where(
      Ingredient.arel_table[:name].matches_any(format_ingredients)
    )
  end

  def by_tags(relation)
    relation.joins(:tags).where(
      Gutentag::Tag.arel_table[:name].matches_all(@tags)
    )
  end

  def format_ingredients
    @ingredients.compact.map { |i| "%#{i}%" }
  end
end
