class Score < ActiveRecord::Base
  belongs_to :student
  has_one :teacher
  attr_accessible :student_id, :teacher_id, :text_id, :value
end
