# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# I may need this later
# ALTER TABLE boards AUTO_INCREMENT = 1

# Create the root Board
Board.create( name: "Main",
              description: "Top level discussion board.",
              parent: nil,
              id: 1)

User.create!(name:  "Mike",
             email: "mikeo.lz17@gmail.com",
             password:              "password",
             password_confirmation: "password",
             admin: true )

99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
    User.create!(name: name,
                 email: email,
                 password:              password,
                 password_confirmation: password)
end