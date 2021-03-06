class Team < ApplicationRecord
  serialize :gameweek_scores, Hash
  serialize :gameweek_points, Hash
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

  def players_during_gameweek(gameweek)
    all_time_players.where('gameweek_in <= ? and (gameweek_out > ? or gameweek_out is null)', gameweek, gameweek)
  end

  def captain_during_gameweek(gameweek)
    players_during_gameweek(gameweek).where("captain = 't'").first
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
    resp = HTTParty.get('https://fantasy.premierleague.com/api/bootstrap-static/')
    if resp['events'].nil?
      return Gameweek.where("deadline_time_epoch < ?", Time.now.to_i).last.gameweek + 1
    end

    first_unfinished_event = resp['events'].find{|e| e['finished'] == false}
    return 38 if first_unfinished_event.nil?

    first_unfinished_event['id']
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
