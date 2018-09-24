# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  # Associations
  has_and_belongs_to_many :collect
  has_many :schedule, dependent: :destroy
  has_many :address

  # Validates

  # Scopes

  # Methods

end
