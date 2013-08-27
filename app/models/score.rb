class Score < ActiveRecord::Base
  belongs_to :student
  belongs_to :text
  has_one :teacher
  attr_accessible :student_id, :teacher_id, :text_id, :value

  def names
    ['Not applicable', 'Successful', 'Needs development', 'Fail']
  end

  def name
    names[self.value]
  end

end
