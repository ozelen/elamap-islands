class Session < ActiveRecord::Base
  attr_accessible :end, :name, :start, :student_id
end
