class Session < ActiveRecord::Base
  has_many :units, :dependent => :destroy, :order => "letter ASC"
  has_many :scores, through: :student
  belongs_to :student
  attr_accessible :end, :name, :start, :student_id, :student
  has_attached_file :image
end
