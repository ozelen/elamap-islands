class Text < ActiveRecord::Base
  belongs_to :unit
  has_many :scores
  has_many :students, through: :scores
  attr_accessible :author, :genre, :lessons, :lexiles, :name, :performance, :unit, :genre, :sequence, :unit_id
end
