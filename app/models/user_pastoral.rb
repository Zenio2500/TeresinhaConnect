class UserPastoral < ApplicationRecord
    acts_as_paranoid
    
    belongs_to :user
    belongs_to :pastoral

    validates :user_id, presence: true
    validates :pastoral_id, presence: true

    validates :user_id, uniqueness: { 
        scope: :pastoral_id,
        conditions: -> { where(deleted_at: nil) },
        message: "já está associado a esta pastoral."
     }
end