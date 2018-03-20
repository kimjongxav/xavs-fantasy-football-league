class Match < ApplicationRecord
  belongs_to :team
  belongs_to :league

  validates :league_id, presence: true
  validates :home_team_id, presence: true
  validates :away_team_id, presence: true
  validates :home_score, presence: true
  validates :away_score, presence: true
  validates :gameweek, presence: true
end
