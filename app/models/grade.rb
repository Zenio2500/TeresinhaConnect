class Grade < ApplicationRecord
    acts_as_paranoid

    has_many :reader_grades
    has_many :readers, through: :reader_grades

    validates :date, presence: { message: "não pode ficar em branco." }
    validates :liturgical_color, format: { with: /\A#[0-9a-fA-F]{6}\z/, message: 'deve estar no formato hexadecimal (#RRGGBB)' }
end