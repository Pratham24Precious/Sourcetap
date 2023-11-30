class AdminUser < ApplicationRecord
  has_secure_password

  validates :name, :email, presence: true
  validates :email, uniqueness: true
end
