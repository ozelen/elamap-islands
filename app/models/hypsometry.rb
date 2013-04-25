class Hypsometry < ActiveRecord::Base
  attr_accessible :color, :name, :position
  default_scope order('position ASC')
end
