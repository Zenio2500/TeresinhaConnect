class Reader < ApplicationRecord
    acts_as_paranoid

    belongs_to :user

    has_many :reader_grades
    has_many :grades, through: :reader_grades

    validates :user_id,
        presence: { message: "não pode ficar em branco." },
        uniqueness: { message: "já é um leitor." }
end