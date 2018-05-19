class Bid < ApplicationRecord
  belongs_to :team
  belongs_to :player
  belongs_to :league

<<<<<<< Updated upstream
  validates :team_id, presence: true
  validates :player_id, presence: true
  validates :value, presence: true
=======
  validates :team_id, :presence => true
  validates :player_id, :presence => true
  validates :league_id, :presence => true
  validates :value, :presence => true
>>>>>>> Stashed changes
end
