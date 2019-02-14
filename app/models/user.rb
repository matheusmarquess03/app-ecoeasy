# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:login]
  include DeviseTokenAuth::Concerns::User

  # Associations
  has_many :schedule, dependent: :destroy

  # Validates
  validates :cpf, cpf: true

  # Scopes

  # Methods
end
