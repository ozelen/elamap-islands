class Session < ActiveRecord::Base
  has_many :units, :dependent => :destroy
  belongs_to :student
  attr_accessible :end, :name, :start, :student_id, :student
end
