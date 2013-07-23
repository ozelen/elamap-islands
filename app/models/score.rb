class Score < ActiveRecord::Base
  attr_accessible :student_id, :teacher_id, :text_id, :value
end
