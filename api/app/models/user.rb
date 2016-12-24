# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  password   :string
#  role       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Represent an user inside system.
#
# There are 3 kinds of user ADMIN, USER, GUEST
# the default is GUEST
#
class User < ActiveRecord::Base
  before_save :encrypt_password!

  validates :name, presence: true
  validates :password, presence: true

  ROLE_ADMIN = 1
  ROLE_USER  = 2
  ROLE_GUEST = 3

  def self.authenticate(name, pass, role)
    user = find_by_name(name)
    user && user.auth?(pass) && user.is_a?(role)
  end

  def auth?(password)
    self.password == encrypted(password)
  end

  def is_a?(role)
    self.role <= role
  end

  def as_json(options = {})
    super(options.merge(except: [:password]))
  end

  private

  def encrypt_password!
    self.password = encrypted(password)
  end

  def encrypted(password)
    Digest::MD5.hexdigest(password)
  end
end
