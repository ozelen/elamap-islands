class Teacher < ActiveRecord::Base
  belongs_to :user
  accepts_nested_attributes_for :user

  attr_accessible :user_attributes, :school_id, :user_id
end
