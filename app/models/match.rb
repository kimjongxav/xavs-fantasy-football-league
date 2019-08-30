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

def position(pos, team) 
  team.select{|k| pos==k[1]}.map{|k| [k[0],k[2], k[3], k[4], k[5]]}
end 

def playerImage(i, pos) 
  image_tag 'https://platform-static-files.s3.amazonaws.com/premierleague/photos/players/110x140/p' + pos[i][2] + '.png' 
end 

def teamScore()
  players.map{ |pl| pl.gameweek_points[@match.gameweek] || 0}.sum + (captain.gameweek_points[@match.gameweek] || 0)
end

def linktoName()
  link_to squad.name, squad
end