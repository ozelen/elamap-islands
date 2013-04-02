class Unit < ActiveRecord::Base
  has_many :texts
  attr_accessible :name, :texts
end
