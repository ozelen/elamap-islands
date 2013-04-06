class Unit < ActiveRecord::Base
  has_many :texts, :dependent => :destroy
  belongs_to :session
  attr_accessible :name, :texts, :letter, :session, :session_id
end
