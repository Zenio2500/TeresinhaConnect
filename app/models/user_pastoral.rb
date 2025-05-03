class UserPastoral < ApplicationRecord
    belongs_to :user
    belongs_to :pastoral

    validates :user_id, presence: true
    validates :pastoral_id, presence: true

    validates :user_id, uniqueness: { scope: :pastoral_id }
end