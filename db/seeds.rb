# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

TagTopic.create([{ topic: 'news' }, { topic: 'comedy' }, { topic: 'biography' }, 
  { topic: 'self-improvement' }, { topic: 'technology'}, { topic: 'search' }, { topic: 'diy' }])

Tagging.create([{ tag_id: 6, link_id: 1 }, { tag_id: 1, link_id: 1 }, { tag_id: 3, link_id: 2 },
  { tag_id: 4, link_id: 1 }])