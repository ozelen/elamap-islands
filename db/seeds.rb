require 'csv'

Student.delete_all
Session.delete_all
Unit.delete_all
Text.delete_all

csv = {
  'students' => nil,
  'sessions' => nil,
  'units' => nil,
  'books' => nil
}

csv.each do |key, val|
  csv[key] = CSV.read('app/assets/csv/' + key + '.csv', {:headers => true, :return_headers => true, :header_converters => :symbol, :converters => :all} )
end

csv['students'].each { |row|
  unit = Student.create(username: row[0], first_name: row[1], last_name: row[2], email: row[3], group_id: 1)
}

csv['sessions'].each { |row|
  Session.create(name: row[0], start: row[1], :end => row[2], student: Student.where(:username => row[3]).first)
}

csv['units'].each { |row|
  # letter,name
  Unit.create(letter: row[0], name: row[2], session: Session.where(:name => row[1]).first)
}

csv['books'].each { |row|
  # Text,Time,Sequence,Genre,Lessons,Lexiles,Performance,Unit
  Text.create(name: row[0], lessons: row[4], lexiles: row[5], genre: row[3], sequence: row[2], performance: row[6], unit: Unit.where(:letter => row[7]).first)
}

