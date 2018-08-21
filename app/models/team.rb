class Team < ApplicationRecord
  serialize :gameweek_scores, Hash
  serialize :properties, Hash
  belongs_to :user
  belongs_to :league

  has_many :player_team_relationships
  has_many :players, :through => :player_team_relationships
  has_many :bids
  has_many :matches

  def all_time_players
    self.players
  end

  def current_players
    all_time_players.where('gameweek_in <= ? and gameweek_out is null', gameweek)
  end

  def current_captain
    current_players.where("captain = 't'").first
  end

  def formation
    number_of_def = current_players.where(:position => 'DEF').count
    number_of_mid = current_players.where(:position => 'MID').count
    number_of_fwd = current_players.where(:position => 'FWD').count
    "(#{number_of_def}-#{number_of_mid}-#{number_of_fwd})"
  end

  def ex_players
    all_time_players.where('gameweek_out is not null')
  end

  def gameweek
    url = 'https://fantasy.premierleague.com/drf/bootstrap-static'
    response = HTTParty.get(url)
    1 unless response
    body = JSON.parse(response.body)
    gameweek = body['current-event'] if response.ok?
    finished = body['events'].select { |e| e['id'] == 1 }.first['finished']
    return gameweek + 1 if finished
    gameweek
  end

  def sort_by_position(players)
    positions = {
      'GK' => 1,
      'DEF' => 2,
      'MID' => 3,
      'FWD' => 4,
    }
    players.sort_by do |player|
      positions[player.position]
    end
  end
end
