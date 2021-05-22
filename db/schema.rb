# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_210_520_123_258) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'gutentag_taggings', id: :serial, force: :cascade do |t|
    t.integer 'tag_id', null: false
    t.integer 'taggable_id', null: false
    t.string 'taggable_type', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['tag_id'], name: 'index_gutentag_taggings_on_tag_id'
    t.index %w[taggable_type taggable_id tag_id], name: 'unique_taggings', unique: true
    t.index %w[taggable_type taggable_id], name: 'index_gutentag_taggings_on_taggable_type_and_taggable_id'
  end

  create_table 'gutentag_tags', id: :serial, force: :cascade do |t|
    t.string 'name', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'taggings_count', default: 0, null: false
    t.index ['name'], name: 'index_gutentag_tags_on_name', unique: true
    t.index ['taggings_count'], name: 'index_gutentag_tags_on_taggings_count'
  end

  create_table 'ingredients', force: :cascade do |t|
    t.string 'name', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['name'], name: 'index_ingredients_on_name', unique: true
  end

  create_table 'ingredients_recipes', force: :cascade do |t|
    t.bigint 'recipe_id', null: false
    t.bigint 'ingredient_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['ingredient_id'], name: 'index_ingredients_recipes_on_ingredient_id'
    t.index ['recipe_id'], name: 'index_ingredients_recipes_on_recipe_id'
  end

  create_table 'recipes', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'image'
    t.string 'author'
    t.string 'author_tip'
    t.string 'people_quantity'
    t.string 'rate'
    t.integer 'budget', null: false
    t.integer 'difficulty', null: false
    t.string 'cook_time'
    t.string 'prep_time'
    t.string 'total_time'
    t.string 'nb_comments'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['budget'], name: 'index_recipes_on_budget'
    t.index ['difficulty'], name: 'index_recipes_on_difficulty'
    t.index ['name'], name: 'index_recipes_on_name', unique: true
  end

  add_foreign_key 'ingredients_recipes', 'ingredients'
  add_foreign_key 'ingredients_recipes', 'recipes'
end
