# frozen_string_literal: true

class CreateRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :recipes do |t|
      t.string :name, null: false
      t.string :image

      t.string :author
      t.string :author_tip

      t.string :people_quantity

      t.string :rate

      t.integer :budget, index: true, null: false
      t.integer :difficulty, index: true, null: false

      t.string :cook_time
      t.string :prep_time
      t.string :total_time

      t.string :nb_comments

      t.timestamps
    end

    add_index :recipes, :name, unique: true
  end
end
