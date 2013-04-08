class Student < ActiveRecord::Base
  has_many :sessions, :dependent => :destroy
  attr_accessible :email, :first_name, :group_id, :last_name, :username
end
