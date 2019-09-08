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

def pstn(pos, team)
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

def showImages(array)
  array.length.times do |i|
    ('<a href=' + array[i][3] + '>').html_safe
        '<div class="player">'.html_safe
        if array[i][4] == false
          '<div class="image">'.html_safe
        else
          '<div class="captainimage">'.html_safe
        end

            playerImage(i, array)

        '</div>'.html_safe

        '<div class="name">'.html_safe
            (array[i][0].to_s + '-' + array[i][1].to_s).html_safe
        '</div>'.html_safe
    '</div>'.html_safe
    '</a>'.html_safe
  end
end

def inPosition(pos, side)
  
  '<div class="positioning">'.html_safe

    array = pstn(pos,side)
      
    showImages(array)

  '</div>'.html_safe
  
end

def setPitch(team)

  if team=="home"
    squad = @match.home_team
    players = @home_players
    captain = @home_captain
  else
    squad = @match.away_team
    players = @away_players
    captain = @away_captain
  end

  '<div class= "' + team + '" >'.html_safe    
    
    '<div class="team-score">'.html_safe 
      (link_to squad.name, squad) + '-' + (players.map{ |pl| pl.gameweek_points[@match.gameweek] || 0}.sum + (captain.gameweek_points[@match.gameweek] || 0)).to_s
    '</div>'.html_safe 

    '<div class="pitch">'.html_safe 

      side = []

      (0..10).each do |i|
        side.push([players[i].common_name, players[i].position, players[i].gameweek_points[@match.gameweek], players[i].picture, (link_to "", players[i])[9..-7], players[i].id == captain.id])
      end

      side = side.sort_by{|k|k[1]}

      inPosition("GK", side)

      inPosition("DEF", side)

      inPosition("MID", side)

      inPosition("FWD", side)
          
    '</div>'.html_safe 
  '</div>'.html_safe 
end