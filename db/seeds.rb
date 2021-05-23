# frozen_string_literal: true

require 'ndjson'

def statistics(parser)
  difficulties = Set.new
  budgets = Set.new
  ingredients = Hash.new(0)
  parser.each do |l|
    difficulties << l['difficulty']
    budgets << l['budget']
    l['ingredients'].each do |i|
      ingredients[i] += 1
    end
  end

  p difficulties
  p budgets
end

def seed(parser)
  ingredients_h = {}
  ingredients_h.default_proc = proc { |h, k| h[k] = Ingredient.find_or_create_by!(name: k) }
  parser.each do |l|
    ActiveRecord::Base.transaction do
      r = Recipe.find_or_initialize_by(l.slice('name', 'budget', 'prep_time', 'author', 'people_quantity', 'total_time',
                                               'image', 'nb_comments', 'difficulty', 'cook_time', 'rate', 'author_tip'))
      r.tag_names = l['tags']
      ingredients = l['ingredients'].map do |n|
        ingredients_h[n]
      end
      r.ingredients = ingredients
      r.save!
      p l['name']
    end
  end
end

parser = NDJSON::Parser.new(File.open(Rails.root.join("db", "seeds", "recipes.json")))
seed(parser)
