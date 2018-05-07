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
20.times do
  name = Faker::Address.city
  short_name = name.slice(0..2).upcase
  PremierLeagueTeam.create!(
    name: name,
    short_name: short_name
  )
end

def position(n)
  # 40 GK, 220 DEF, 220 MID, 120 STR
  if n <= 40
    'GK'
  elsif n <= 260
    'DEF'
  elsif n <= 480
    'MID'
  else
    'FWD'
  end
end

# players
600.times do |n|
  surname = Faker::Name.last_name
  full_name = "#{Faker::Name.first_name} #{surname}"
  position = position(n)
  Player.create!(
    full_name: full_name,
    common_name: surname,
    position: position,
    premier_league_team_id: (n % 20) + 1,
    fantasy_football_id: 1
  )
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

# todo
# create seeds for: bids, matches