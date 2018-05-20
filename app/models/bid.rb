class Bid < ApplicationRecord
  belongs_to :team
  belongs_to :player

  validates :team_id, :presence => true
  validates :player_id, :presence => true
  validates :value, :presence => true
end
