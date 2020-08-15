# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# id a need of purge database at each rails db:seed
# Cocktail.destroy_all
# Ingredient.destroy_all

require 'json'
require 'open-uri'

url = 'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail'
drink_serialized = open(url).read
drink = JSON.parse(drink_serialized)

drink["drinks"].each do |attributes|
  # upload photo in cloudinary
  # photo = Cloudinary::Uploader.upload(attributes["strDrinkThumb"])
  # p photo
  img = URI.open(attributes['strDrinkThumb'])
  # create cocktail
  p cocktail = Cocktail.create!(name: attributes["strDrink"])
  cocktail.photo.attach(io: img, filename: "#{attributes['strDrink']}.png", content_type: 'image/png')
  cocktail.save
  idCocktail = attributes["idDrink"]
  url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=#{idCocktail}"
  cocktailDetails_serialized = open(url).read
  cocktailDetails = JSON.parse(cocktailDetails_serialized)
    cocktailDetails["drinks"].each do |attributes|

  # create ingredient
  i = 1
  until attributes["strIngredient#{i}"] == nil || attributes["strIngredient#{i}"].blank?  do
    p attributes["strIngredient#{i}"] + " ingredient #{i}"
    search_ingredient = Ingredient.where(name: attributes["strIngredient#{i}"])
      if search_ingredient[0].nil?
        ingredient = Ingredient.create!(name: attributes["strIngredient#{i}"])
      else
        ingredient = search_ingredient[0]
      end
      p ingredient
      #   puts "Created #{ingredient.name}"
      # # create dose
      if  attributes["strMeasure#{i}"].blank? == false
        p dose = Dose.create!(description: attributes["strMeasure#{i}"],ingredient_id: ingredient[:id] , cocktail_id: cocktail[:id])
      end
      # end
      i = i + 1
  end
    puts "Ingredients seeding finished!"
end
end
# raise
# puts "Cocktails seeding finished!"

# url = 'https://www.thecocktaildb.com/api/json/v1/1/search.php?f=a'
# drink_serialized = open(url).read
# drink = JSON.parse(drink_serialized)

# drink["ingredients"].each do |attributes|
#   ingredient = Ingredient.create!(name: attributes["strIngredient"])
#   puts "Created #{ingredient.name}"
# end
# rake db:purge
# rails db:migrate
# rails db:seed

# puts "Ingredients seeding finished!"

# url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
# drink_serialized = open(url).read
# drink = JSON.parse(drink_serialized)

# drink["ingredients"].each do |attributes|
#   ingredient = Ingredient.create!(name: attributes["strIngredient1"])
#   puts "Created #{ingredient.name}"
# end

# puts "Doses seeding finished!"
