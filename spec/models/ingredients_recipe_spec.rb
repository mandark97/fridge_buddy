# == Schema Information
#
# Table name: ingredients_recipes
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  ingredient_id :bigint           not null
#  recipe_id     :bigint           not null
#
# Indexes
#
#  index_ingredients_recipes_on_ingredient_id  (ingredient_id)
#  index_ingredients_recipes_on_recipe_id      (recipe_id)
#
# Foreign Keys
#
#  fk_rails_...  (ingredient_id => ingredients.id)
#  fk_rails_...  (recipe_id => recipes.id)
#
require 'rails_helper'

RSpec.describe IngredientsRecipe, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
