class Pastoral < ApplicationRecord
	acts_as_paranoid

    has_many :user_pastorals
    has_many :users, through: :user_pastorals

    belongs_to :coordinator, class_name: "User", foreign_key: "coordinator_id"
    belongs_to :vice_coordinator, class_name: "User", foreign_key: "vice_coordinator_id"

    validates :name,
        presence: { message: "não pode ficar em branco." },
        uniqueness: { message: "já está cadastrada." }
    validates :coordinator_id, presence: { message: "não pode ficar em branco." }
    validates :vice_coordinator_id, presence: { message: "não pode ficar em branco." }
end