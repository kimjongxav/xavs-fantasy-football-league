class Match < ApplicationRecord
  belongs_to :home_team, :class_name => 'Team'
  belongs_to :away_team, :class_name => 'Team'
  belongs_to :league

  validates :league_id, :presence => true
  validates :home_team_id, :presence => true
  validates :away_team_id, :presence => true
  validates :gameweek, :presence => true

  scope :played, -> { where(:played => true) }
  scope :unplayed, -> { where(:played => false) }
end
