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
  p ingredients
  File.open('public/temp.json', 'w') do |f|
    f.write(ingredients.to_json)
  end
end

def seed(parser)
  ingredients_h = {}
  ingredients_h.default_proc = proc { |h, k| h[k] = Ingredient.find_or_create_by!(name: k) }
  parser.each do |l|
    ActiveRecord::Base.transaction do
      r = Recipe.find_or_initialize_by(name: l['name'],
                                       budget: l['budget'],
                                       prep_time: l['prep_time'],
                                       author: l['author'],
                                       people_quantity: l['people_quantity'],
                                       total_time: l['total_time'],
                                       image: l['image'],
                                       nb_comments: l['nb_comments'],
                                       difficulty: l['difficulty'],
                                       cook_time: l['cook_time'],
                                       rate: l['rate'],
                                       author_tip: l['author_tip'])
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

parser = NDJSON::Parser.new(File.open(Rails.root.join('db', 'seeds', 'recipes.json')))
seed(parser)
# parser.each do |l|
#   puts l
# end
