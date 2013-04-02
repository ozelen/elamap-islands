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

Unit.delete_all
Text.delete_all

unit = Unit.create({name: "Personal Narrative"})
texts = Text.create([
                        {unit: unit, name: "Boy", lessons: 10, lexiles: 1090, genre: 3.3, sequence: 1, performance: 1.4},
                        {unit: unit, name: "Life on the Mississippi", lessons: 4, lexiles: 1150, genre: 3.3, sequence:7, performance: 2}
                    ])


unit = Unit.create({name: "Narrative Fiction"})
texts = Text.create([
                        {unit: unit, name: "Raisin in the Sun", sequence: 17, genre: 5.2, lessons: 15, lexiles: 100, performance: 1.7},
                        {unit: unit, name: "Harlem", sequence:24, genre: 6.4, lessons: 1, lexiles: 100, performance: 2}
                    ])