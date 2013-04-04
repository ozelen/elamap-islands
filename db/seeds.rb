require 'csv'


# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#units = Unit.create([
#                        {
#                            name: "Personal Narrative",
#                            texts: [
#                                {name: "Boy", lessons: 10, lexiles: 1090, genre: 3.3, sequence: 1, performance: 1.4},
#                                {name: "Life on the Mississippi", lessons: 4, lexiles: 1150, genre: 3.3, sequence:7, performance: 2}
#                            ]
#                        },
#                        {
#                            name: "Narrative Fiction",
#                            texts: [
#                                {name: "Raisin in the Sun", sequence: 17, genre: 5.2, lessons: 15, lexiles: 100, performance: 1.7},
#                                {name: "Harlem", sequence:24, genre: 6.4, lessons: 1, lexiles: 100, performance: 2}
#                            ]
#                        }
#                    ])


#
#
#unit = Unit.create(name: "Personal Narrative", letter: 'A')
#texts = Text.create([
#                        {unit: Unit.last, name: "Boy", lessons: 10, lexiles: 1090, genre: 3.3, sequence: 1, performance: 1.4},
#                        {unit: Unit.last, name: "Life on the Mississippi", lessons: 4, lexiles: 1150, genre: 3.3, sequence:7, performance: 2}
#                    ])
#
#
#unit = Unit.create({name: "Narrative Fiction", letter: 'B'})
#texts = Text.create([
#                        {unit: Unit.last, name: "Raisin in the Sun", sequence: 17, genre: 5.2, lessons: 15, lexiles: 100, performance: 1.7},
#                        {unit: Unit.last, name: "Harlem", sequence:24, genre: 6.4, lessons: 1, lexiles: 100, performance: 2}
#                    ])


Unit.delete_all
Text.delete_all

csvUnits = CSV.read("app/assets/csv/units.csv", {:headers => true, :return_headers => true, :header_converters => :symbol, :converters => :all} )
csvBooks = CSV.read("app/assets/csv/books.csv", {:headers => true, :return_headers => true, :header_converters => :symbol, :converters => :all} )

csvUnits.each { |row|
  # letter,name
  unit = Unit.create(letter: row[0], name: row[1])
}

csvBooks.each { |row|
  # Text,Time,Sequence,Genre,Lessons,Lexiles,Performance,Unit
  texts = Text.create(name: row[0], lessons: row[4], lexiles: row[5], genre: row[3], sequence: row[2], performance: row[6], unit: Unit.where(:letter => row[7]).first)
}
