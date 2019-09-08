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

def image_link(player)
  "https://platform-static-files.s3.amazonaws.com/premierleague/photos/players/110x140/p#{
    player.picture
  }.png"
end

def home_squad_score_so_far
  @home_players.map do
    |pl| pl.gameweek_points[@match.gameweek] || 0
  end.sum + (@home_captain.gameweek_points[@match.gameweek] || 0)
end

def away_squad_score_so_far
  @away_players.map do
    |pl| pl.gameweek_points[@match.gameweek] || 0
  end.sum + (@away_captain.gameweek_points[@match.gameweek] || 0)
end

def player_score(player)
  if [@home_captain, @away_captain].include?(player)
    2 * (player.gameweek_points[@match.gameweek] || 0)
  else
    player.gameweek_points[@match.gameweek] || 0
  end
end
