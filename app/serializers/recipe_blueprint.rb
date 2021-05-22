class RecipeBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :author, :author_tip, :budget, :cook_time,
         :difficulty, :image, :nb_comments, :people_quantity, :prep_time, :rate, :total_time

  view :extended do
    association :ingredients, blueprint: IngredientBlueprint
    association :tags, blueprint: TagBlueprint
  end
end
