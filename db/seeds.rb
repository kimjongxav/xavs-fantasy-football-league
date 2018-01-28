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
  'GK' if n <= 40
  'DEF' if n <= 260
  'MID' if n <= 480
  'FWD'
end

# players
600.times do |n|
  full_name = Faker::Name.name
  common_name = full_name.split(' ').last
  position = position(n)
  User.create!(
    full_name: full_name,
    common_name: common_name,
    position: position,
    premier_league_team_id: 20 % n
  )
end

# users
15.times do |n|
  name = Faker::Name.name
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

# team
15.times do |n|
  name = Faker::Name.name
  PremierLeagueTeam.create!(
    name: name,
    short_name: short_name,
    user_id: n,
    league_id: 1
  )
end

# todo
# create seeds for: teams, players, leagues, bids, matches, premier league teams