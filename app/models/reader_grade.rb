class ReaderGrade < ApplicationRecord
    acts_as_paranoid

    belongs_to :reader
    belongs_to :grade

    validates :reader_id, presence: { message: "não pode ficar em branco." }
    validates :grade_id, presence: { message: "não pode ficar em branco." }
    validates :reader_type, presence: { message: "não pode ficar em branco." }, 
              inclusion: { in: ['1ª Leitura', '2ª Leitura', 'Salmo', 'Preces'], 
                          message: "deve ser um tipo válido de leitura" }

    validates :reader_id, uniqueness: { 
      scope: :grade_id,
      conditions: -> { where(deleted_at: nil) },
      message: "já está associado a esta escala."
    }
end