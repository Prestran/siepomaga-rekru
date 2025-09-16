class User < ApplicationRecord
  has_secure_password
  has_many :zipper_files, dependent: :destroy
end
