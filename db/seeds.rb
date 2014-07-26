# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

gallery = Gallery.create!

file = File.open(Rails.root.join('public/images/emsi.png'))
picture = gallery.pictures.create image: file

puts "\nhttp://localhost:3000/!#{gallery.slug}"
