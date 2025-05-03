class User < ApplicationRecord
	acts_as_paranoid
	has_secure_password

	has_one :reader
	has_many :readers
	has_many :user_pastorals
	has_many :pastorals, through: :user_pastorals

	validates :name, presence: true
	validates :email,
		presence: { message: "não pode ficar em branco." },
		uniqueness: { message: "já está em uso." },
		format: { with: URI::MailTo::EMAIL_REGEXP, message: "não é um e-mail válido." }
	validates :password_digest, presence: true	
end
