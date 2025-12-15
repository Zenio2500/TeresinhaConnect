class Grade < ApplicationRecord
    acts_as_paranoid

    has_many :reader_grades, dependent: :destroy
    has_many :readers, through: :reader_grades

    validates :date, presence: { message: "não pode ficar em branco." }
    validates :liturgical_color, inclusion: { in: ['Verde', 'Branco', 'Roxo', 'Vermelho', 'Rosa'], 
                                              message: 'deve ser uma cor litúrgica válida.' }, 
                                 allow_blank: true
end