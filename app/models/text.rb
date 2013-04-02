class Text < ActiveRecord::Base
  belongs_to :unit
  attr_accessible :author, :genre, :lessons, :lexiles, :name, :performance, :unit, :genre, :sequence
end
