class Bid < ApplicationRecord
  belongs_to :team
  belongs_to :player

  validates :team_id, :presence => true
  validates :player_id, :presence => true
  validates :value, :presence => true
  validates :window, :presence => true
  validates :round, :presence => true
end
