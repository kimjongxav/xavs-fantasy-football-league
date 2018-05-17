require 'rubygems'
require 'httparty'

resp = HTTParty.get('https://fantasy.premierleague.com/drf/bootstrap-static')
teams = JSON.parse(resp.body)['teams']
players = JSON.parse(resp.body)['elements']

# league
League.create!(
  :season => '2018/2019',
  :name => 'Test League',
)

# admin user
User.create!(
  :name => 'Xavier Lacey',
  :email => 'xavlacey@gmail.com',
  :initials => 'XL',
  :password => 'cookie123',
  :password_confirmation => 'cookie123',
  :admin => true,
  :activated => true,
  :activated_at => Time.zone.now,
)

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
16.times do |n|
  name = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
  initials = name.split.map(&:first).join
  email = "example-#{n + 1}@railstutorial.org"
  password = 'password'
  User.create!(
    :name => name,
    :email => email,
    :initials => initials,
    :password => password,
    :password_confirmation => password,
    :activated => true,
    :activated_at => Time.zone.now,
  )
end

def gameweek_points
  (1..38).map{ 0 }.to_s
end

# teams
16.times do |n|
  name = Faker::Team.name
  Team.create!(
    :name => name,
    :league_id => 1,
    :user_id => n + 1,
    :properties => '{"wins": 0, "losses": 0, "draws": 0, "matches_within_five_points": 0}',
    :gameweek_points => gameweek_points,
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
  gameweek_history = Hash.new

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
Player.all.each do |player|
  PlayerTeamRelationship.create!(
    :player_id => player['id'],
    :team_id => (player['id'] % 16) + 1,
    :gameweek_in => 1,
    :gameweek_out => nil,
    :captain_in => player['id'] <= 16,
    :captain_out => false,
  )
end

def empty_matches
  {
    :home_score => nil,
    :away_score => nil,
    :played => false,
  }
end

def calculate_fixtures(league)
  teams_ids = league.teams.map(&:id)
  first_half_fixtures = []
  second_half_fixtures = []
  team_ids.each do |home_team_id|
    counter = 0
    team_ids.each do |away_team_id|
      next if home_team_id == away_team_id
      if home_team_id < away_team_id
        first_half_fixtures.push(
          empty_matches.merge(
            :home_team_id => home_team_id,
            :away_team_id => away_team_id,
          ),
        )
      else
        second_half_fixtures.unshift(
          empty_matches.merge(
            :home_team_id => home_team_id,
            :away_team_id => away_team_id,
          ),
        )
      end
      counter += 1
    end
  end

  fixtures = (first_half_fixtures.shuffle + second_half_fixtures.shuffle)

  fixtures.each_with_index{ |f, i| f[:gameweek] = i + 1 }
end

# matches
team = Team.first
(1..5).each do |gw|
  Match.create!(
    :league_id => 1,

  )
end

# todo
# create seeds for: bids, matches
