class Student < ActiveRecord::Base
  attr_accessible :email, :first_name, :group_id, :last_name, :username
end
