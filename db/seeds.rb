require 'rubygems'
require 'httparty'
require 'csv'

resp = HTTParty.get('https://fantasy.premierleague.com/drf/bootstrap-static')
teams = JSON.parse(resp.body)['teams']
players = JSON.parse(resp.body)['elements']

# league
League.create!(
  :season => '2018/2019',
  :name => 'Test League',
)

# admin user
# User.create!(
#   :name => 'Xavier Lacey',
#   :email => 'xavlacey@gmail.com',
#   :initials => 'XL',
#   :password => 'cookie123',
#   :password_confirmation => 'cookie123',
#   :admin => true,
#   :activated => true,
#   :activated_at => Time.zone.now,
# )

# premier league teams
teams.each do |team|
  name = team['name']
  short_name = team['short_name']
  PremierLeagueTeam.create!(
    :name => name,
    :short_name => short_name,
  )
end

def position(type)
  # 40 GK, 220 DEF, 220 MID, 120 STR
  if type == 1
    'GK'
  elsif type == 2
    'DEF'
  elsif type == 3
    'MID'
  else
    'FWD'
  end
end

# users
names = [
  'Alex Dyzenhaus',
  'Chris Taylor',
  'Darrelle Wood',
  'Joe Kelly',
  'James Thornton',
  'Kate Wyatt',
  'Nathaniel Melman',
  'Phil Buckingham',
  'Philippe Lacey',
  'Xavier Lacey',
]
initials = %w[AD CT DW JK JT KW NM PB PL XL]
email = %w[
  dyzenhaus@gmail.com
  christr08@gmail.com
  Darrellewood@outlook.com
  joe1kelly37@hotmail.co.uk
  Jamesthornton1@live.co.uk
  k.wyatt@live.com
  nathanielmelman@gmail.com
  Philip.buckingham@hotmail.com
  philippe.lacey@ad-esse.com
  xavlacey@gmail.com
]
teams = [
  'Your Sessegnon Fire',
  'F.C. Lloris Academy 4',
  'Chamakh My Pitch Up United',
  'Real Joeissobad',
  'Aaaaaaaa FC',
  'Hakuna JuanMata FC',
  'Knowing Mee, Knowing Giroud (Zaha) FC',
  'Pun Basedonmyinitials FC',
  'Lupus Non Mordet Lupum AFC',
  'Borussalah VfL 1992 Mönchenxavbach e.V.',
]

10.times do |n|
  email = "#{initials[n].downcase}@xfl.com"
  password = 'password'
  User.create!(
    :name => names[n],
    :email => email,
    :initials => initials[n],
    :password => password,
    :password_confirmation => password,
    :activated => true,
    :activated_at => Time.zone.now,
    :admin => initials[n] == 'XL',
  )
end

# teams
10.times do |n|
  Team.create!(
    :name => teams[n],
    :league_id => 1,
    :user_id => n + 1,
    :properties => '{"wins": 0, "losses": 0, "draws": 0, "matches_within_five_points": 0, "top_weekly": 0, "bottom_weekly": 0, "over_sixty": 0}',
    :gameweek_scores => '{"1": 0 }',
  )
end

# matches for a ten-league team
# every team plays every other team four times
# then the final two weeks are 1v2, 3v4, etc. with two legs

csv_text = File.read(Rails.root.join('lib', 'seeds', 'fixtures.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')

csv.each do |fixture|
  Match.create!(
    :league_id => 1,
    :gameweek => fixture['gameweek'],
    :home_team_id => fixture['home_team_id'],
    :away_team_id => fixture['away_team_id'],
  )
end

# players
players.each do |player|
  surname = player['web_name']
  full_name = "#{player['first_name']} #{player['second_name']}"
  position = position(player['element_type'])

  # Get specific player url
  url = 'https://fantasy.premierleague.com/drf/element-summary/' + player['id'].to_s
  response = HTTParty.get(url)
  next unless response.ok?

  player_match_history = JSON.parse(response.body)['history']
  gameweek_history = {}

  player_match_history.each do |m|
    current_score = gameweek_history[m['round']] || 0
    gameweek_history[m['round']] = m['total_points'] += current_score
  end

  Player.create!(
    :id => player['id'],
    :full_name => full_name,
    :common_name => surname,
    :position => position,
    :premier_league_team_id => player['team'],
    :gameweek_points => '{"1": 0 }',
  )

  puts "done #{full_name}" if (player['id'].to_i % 50).zero?
end

# player team relationships
starting_team_relationships = {
  '1' => [282, 142, 71, 265, 367, 150, 251, 506, 433, 480, 234], # AD
  '2' => [24, 355, 70, 5, 184, 459, 122, 223, 417, 87, 437], # CT
  '3' => [154, 169, 239, 7, 330, 440, 132, 451, 134, 235, 45], # DW
  '4' => [260, 359, 264, 115, 357, 8, 275, 13, 270, 164, 372], # JK
  '5' => [468, 353, 288, 12, 119, 382, 295, 256, 18, 23, 150], # JT
  '6' => [47, 113, 222, 312, 271, 364, 59, 272, 432, 257, 326], # KW
  '7' => [400, 267, 118, 117, 465, 14, 302, 172, 346, 158, 281], # NM
  '8' => [351, 359, 293, 262, 273, 271, 365, 256, 124, 22, 280], # PB
  '9' => [67, 247, 192, 246, 49, 126, 76, 434, 339, 300, 107], # PL
  '10' => [2, 28, 222, 4, 393, 478, 253, 370, 440, 236, 305], # XL
}

captains = [234, 122, 239, 372, 23, 257, 302, 280, 300, 253]

starting_team_relationships.each do |team_id, player_ids|
  player_ids.each do |player_id|
    puts "team_id #{team_id}, player_id #{player_id}"
    PlayerTeamRelationship.create!(
      :player_id => player_id,
      :team_id => team_id,
      :gameweek_in => 1,
      :gameweek_out => nil,
      :captain_in => captains.include?(player_id),
      :captain_out => false,
    )
  end
end
