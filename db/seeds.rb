require 'rubygems'
require 'httparty'

resp = HTTParty.get('https://fantasy.premierleague.com/drf/bootstrap-static')
teams = JSON.parse(resp.body)['teams']
players = JSON.parse(resp.body)['elements']

# league
League.create!(
  season: '2018/2019',
  name: 'Test League'
)

# admin user
User.create!(
  name: 'Xavier Lacey',
  email: 'xavlacey@gmail.com',
  initials: 'XL',
  password: 'cookie123',
  password_confirmation: 'cookie123',
  admin: true,
  activated: true,
  activated_at: Time.zone.now
)

# premier league teams
teams.each do |team|
  name = team['name']
  short_name = team['short_name']
  PremierLeagueTeam.create!(
    name: name,
    short_name: short_name
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
15.times do |n|
  name = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
  initials = name.split.map(&:first).join
  email = "example-#{n + 1}@railstutorial.org"
  password = 'password'
  User.create!(
    name: name,
    email: email,
    initials: initials,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now
  )
end

# teams
15.times do |n|
  name = Faker::Team.name
  Team.create!(
    name: name,
    user_id: n + 1,
    league_id: 1,
    properties: '{"wins": 0, "losses": 0, "draws": 0, "matches_within_five_points": 0}'
  )
end

# players
players.each do |player|
  surname = player['web_name']
  full_name = "#{player['first_name']} #{player['second_name']}"
  position = position(player['element_type'])

   # Get specific player url
   url = 'https://fantasy.premierleague.com/drf/element-summary/' << player['id'].to_s
   response = HTTParty.get(url)
 
    # Get specific player url
    url = 'https://fantasy.premierleague.com/drf/element-summary/' << player['id'].to_s
    response = HTTParty.get(url)
  
    # Gives hisory of the player
    history_raw = JSON.parse(response.body)['history']
 
  
    # Gives the round number as the key
    round_as_key = history_raw.collect { |p| {p['round'] => p['total_points'] }}
  
    # Consolidates keys, adds round number when there are multiple keys
    points_tidy = round_as_key.each_with_object({}) { |h,g| g.update(h) { |_,o,n| o+n } }
  
    # Prepend points_in_gameweek to Key
    pig_hash = Hash[points_tidy.map{|k,v| [k.to_s.dup.prepend("points_in_gameweek_"),v]}]
   

   

  Player.create!(
    pig_hash.merge(
      id: player['id'],
      full_name: full_name,
      common_name: surname,
      position: position,
      premier_league_team_id: player['team'],
      fantasy_football_id: 1,
      team_id: rand(1..15),
    )
    
    
  )

  
end

# todo
# create seeds for: bids, matches