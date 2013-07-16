class User < ActiveRecord::Base
  before_create :create_role
  acts_as_authentic do |c|
    c.login_field = 'username'
  end
  attr_accessible :username, :email, :password, :password_confirmation, :roles

  has_many :users_roles
  has_many :roles, :through => :users_roles

  #ROLES = Role.all # %w[admin moderator author]
  ROLES = %w[admin teacher reviewer]

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  def role_symbols
    roles.map(&:to_sym)
  end

  def roles_map
    self.roles.map { |r| r.name}
  end

  def role?(role)
    #rol = self.roles.map { |r| r.name}
    #rol.include?(role.to_s)
    self.roles.include? role.to_s
  end

  private
    def create_role
      self.roles << Role.find_by_name(:user)
    end
end
