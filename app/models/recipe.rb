# == Schema Information
#
# Table name: recipes
#
#  id              :bigint           not null, primary key
#  author          :string
#  author_tip      :string
#  budget          :integer          not null
#  cook_time       :string
#  difficulty      :integer          not null
#  image           :string
#  name            :string           not null
#  nb_comments     :string
#  people_quantity :string
#  prep_time       :string
#  rate            :string
#  total_time      :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_recipes_on_budget      (budget)
#  index_recipes_on_difficulty  (difficulty)
#  index_recipes_on_name        (name) UNIQUE
#
class Recipe < ApplicationRecord
  Gutentag::ActiveRecord.call self

  enum difficulty: { 'très facile' => 0, 'Niveau moyen' => 1, 'facile' => 2, 'difficile' => 3 }
  enum budget: { 'bon marché' => 0, 'Coût moyen' => 1, 'assez cher' => 2 }

  has_many :ingredients_recipes
  has_many :ingredients, through: :ingredients_recipes
end
