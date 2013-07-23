class Student < ActiveRecord::Base
  has_many :sessions, :dependent => :destroy
  has_many :scores
  attr_accessible :email, :first_name, :group_id, :last_name, :username

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def score_by(text)
    self.scores.find_by_text_id(text.id) if text
  end

end
