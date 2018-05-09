class PremierLeagueTeamsController < ApplicationController
  before_action :logged_in_user, only: [:index]

  def index
    @premier_league_teams = PremierLeagueTeam.paginate(page: params[:page])
  end

  def show
    @premier_league_team = PremierLeagueTeam.find(params[:id])
    unsorted_players = Player.where(:premier_league_team_id => @premier_league_team.id)
    @players = sort_by_position(unsorted_players)
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

  def new
  end
end
