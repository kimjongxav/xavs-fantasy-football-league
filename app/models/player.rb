class Player < ApplicationRecord
  serialize :gameweek_points, Hash
  belongs_to :premier_league_team

  has_many :bids
  has_many :player_team_relationships
  has_many :teams, :through => :player_team_relationships

  validates :full_name, :presence => true, length: { maximum: 100 }
  validates :common_name, :presence => true, length: { maximum: 50 }
  validates :position, :presence => true, length: { maximum: 10 }
  validates :premier_league_team_id, :presence => true

  def team_points(gameweek_in, captain)
    points = gameweek_points.select { |k| k >= gameweek_in }.values.sum

    return points * 2 if captain
    points
  end

  def owned?
    PlayerTeamRelationship.where(:player_id => self.id, :gameweek_out => nil).any?
  end
end
