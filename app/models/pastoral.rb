class Pastoral < ApplicationRecord
	acts_as_paranoid

    has_many :user_pastorals
    has_many :users, through: :user_pastorals

    belongs_to :coordinator, class_name: "User", foreign_key: "coordinator_id"
    belongs_to :vice_coordinator, class_name: "User", foreign_key: "vice_coordinator_id"

    validates :name,
        presence: { message: "não pode ficar em branco." },
        uniqueness: {
            conditions: -> { where(deleted_at: nil) },
            message: "já está cadastrada."
        }
    validates :coordinator_id, presence: { message: "não pode ficar em branco." }
    validates :vice_coordinator_id, presence: { message: "não pode ficar em branco." }

    before_validation :check_coordinators
    after_save :update_coordinator_status
    before_destroy :update_coordinator_status_on_destroy

    def check_coordinators
        if coordinator_id == vice_coordinator_id
            errors.add(:base, "Coordenador não pode ser o mesmo que o vice-coordenador.")
            throw :abort
        end
    end

    private

    def update_coordinator_status
        coordinator&.update_column(:is_coordinator, true)
        vice_coordinator&.update_column(:is_coordinator, true)
        UserPastoral.create(user: coordinator, pastoral: self) unless UserPastoral.exists?(user: coordinator, pastoral: self)
        UserPastoral.create(user: vice_coordinator, pastoral: self) unless UserPastoral.exists?(user: vice_coordinator, pastoral: self)

        if saved_change_to_coordinator_id?
            old_coordinator_id = coordinator_id_before_last_save
            UserPastoral.find_by(user: old_coordinator_id, pastoral: self)&.destroy
            check_and_update_coordinator_status(old_coordinator_id) if old_coordinator_id
        end

        if saved_change_to_vice_coordinator_id?
            old_vice_id = vice_coordinator_id_before_last_save
            UserPastoral.find_by(user: old_vice_id, pastoral: self)&.destroy
            check_and_update_coordinator_status(old_vice_id) if old_vice_id
        end
    end

    def update_coordinator_status_on_destroy
        UserPastoral.where(pastoral_id: id).destroy_all
        if name.downcase == "liturgia"
            ReaderGrade.destroy_all
            Reader.destroy_all
            Grade.destroy_all
        end
        check_and_update_coordinator_status(coordinator_id)
        check_and_update_coordinator_status(vice_coordinator_id)
    end

    def check_and_update_coordinator_status(user_id)
        return unless user_id

        user = User.find_by(id: user_id)
        return unless user

        is_coordinator = Pastoral.where(coordinator_id: user_id)
                                 .or(Pastoral.where(vice_coordinator_id: user_id))
                                 .exists?

        user.update_column(:is_coordinator, is_coordinator)
    end
end