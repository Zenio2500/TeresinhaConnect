class Reader < ApplicationRecord
    acts_as_paranoid

    belongs_to :user

    has_many :reader_grades
    has_many :grades, through: :reader_grades

    validates :user_id,
        presence: { message: "não pode ficar em branco." },
        uniqueness: { 
            conditions: -> { where(deleted_at: nil) },
            message: "já é um leitor."
         }

    after_create :add_user_to_liturgia_pastoral
    before_destroy :remove_user_from_liturgia_pastoral

    private

    def add_user_to_liturgia_pastoral
        liturgia_pastoral = Pastoral.find_by("LOWER(name) = ?", "liturgia")
        
        if liturgia_pastoral && user
            # Verificar se já não está associado
            unless user.pastorals.include?(liturgia_pastoral)
                UserPastoral.create(user: user, pastoral: liturgia_pastoral)
            end
        end
    end

    def remove_user_from_liturgia_pastoral
        liturgia_pastoral = Pastoral.find_by("LOWER(name) = ?", "liturgia")
        
        if liturgia_pastoral && user
            # Remover a associação do usuário com a pastoral Liturgia
            unless liturgia_pastoral.coordinator_id == user.id || liturgia_pastoral.vice_coordinator_id == user.id
                user_pastoral = UserPastoral.find_by(user: user, pastoral: liturgia_pastoral)
                user_pastoral&.destroy
            end
            ReaderGrade.where(reader_id: id).destroy_all
        end
    end
end