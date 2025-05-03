class ReaderGrade < ApplicationRecord
    acts_as_paranoid

    belongs_to :reader
    belongs_to :grade

    validates :reader_id, presence: { message: "não pode ficar em branco." }
    validates :grade_id, presence: { message: "não pode ficar em branco." }

    validates :reader_id, uniqueness: { scope: :grade_id }
end