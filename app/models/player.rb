class Player < ApplicationRecord
  belongs_to :premier_league_team

  has_many :bids
  has_many :player_team_relationships
  has_many :teams, :through => :player_team_relationships

  validates :full_name, :presence => true, length: { maximum: 100 }
  validates :common_name, :presence => true, length: { maximum: 50 }
  validates :position, :presence => true, length: { maximum: 10 }
  validates :premier_league_team_id, :presence => true


  def team_points(gameweek_in, captain)
    points = JSON.parse(self.gameweek_points).select { |k| k >= gameweek_in.to_s }.values.sum

    points unless captain
    points * 2
  end
end
