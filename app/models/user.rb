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

	before_destroy :replace_pastoral_references

	private

	def replace_pastoral_references
		general_pastoral = Pastoral.where("LOWER(name) = ?", "geral").first
		
		unless general_pastoral
			errors.add(:base, "Não é possível excluir o usuário: a pastoral 'Geral' não foi encontrada.")
			throw :abort
		end

		replacement_user_id = general_pastoral.coordinator_id

		unless replacement_user_id
			errors.add(:base, "Não é possível excluir o usuário: a pastoral 'Geral' não possui um coordenador definido.")
			throw :abort
		end

		if replacement_user_id == id
			errors.add(:base, "Não é possível excluir o coordenador da pastoral 'Geral'. Por favor, substitua o coordenador da pastoral 'Geral' antes de excluir este usuário.")
			throw :abort
		end

		Pastoral.where(coordinator_id: id).update_all(coordinator_id: replacement_user_id)
		Pastoral.where(vice_coordinator_id: id).update_all(vice_coordinator_id: replacement_user_id)
		UserPastoral.where(user_id: id).destroy_all
		readers = Reader.where(user_id: id)
		ReaderGrade.where(reader_id: readers.pluck(:id)).destroy_all
		readers.destroy_all
	end
end
