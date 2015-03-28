# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Clear out the Board table

Board.all.each do |b| 
    b.destroy
end

# Create the root Board
Board.create( name: "Main",
              description: "Top level discussion board.",
              parent: nil,
              id: 1)