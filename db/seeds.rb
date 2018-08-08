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
  'JK',
  'Aaaaaaaa FC',
  'Hakuna JuanMata FC',
  'MelMan City',
  'Pun Basedonmyinitials FC',
  'Lupus Non Mordet Lupum AFC',
  'Borussalah VfL 1992 Mönchenxavbach e.V.',
]

10.times do |n|
  email = "#{initials[n].downcase}@example.com"
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
    :properties => '{"wins": 0, "losses": 0, "draws": 0, "matches_within_five_points": 0}',
    :gameweek_points => {},
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
    :gameweek_points => gameweek_history.to_json,
  )

  puts "done #{full_name}" if (player['id'].to_i % 50).zero?
end

# player team relationships
# Player.all.each do |player|
#   PlayerTeamRelationship.create!(
#     :player_id => player['id'],
#     :team_id => (player['id'] % 16) + 1,
#     :gameweek_in => 1,
#     :gameweek_out => nil,
#     :captain_in => player['id'] <= 16,
#     :captain_out => false,
#   )
# end
