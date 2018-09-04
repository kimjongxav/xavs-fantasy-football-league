class MatchesController < ApplicationController
  before_action :logged_in_user, :only => [:index]

  def index
    @matches = Match.all
  end

  def show
    @match = Match.find(params[:id])
    @home_team = @match.home_team
    @away_team = @match.away_team
    @home_players = sort_by_position(home_players)
    @away_players = sort_by_position(away_players)
    @home_captain = home_captain
    @away_captain = away_captain
  end

  def new
  end

  def home_players
    @home_team.players.where('gameweek_in <= ? and (gameweek_out is null or gameweek_out > ?)', @match.gameweek, @match.gameweek)
  end

  def away_players
    @away_team.players.where('gameweek_in <= ? and (gameweek_out is null or gameweek_out > ?)', @match.gameweek, @match.gameweek)
  end

  def home_captain
    PlayerTeamRelationship.where(:team_id => @home_team.id, :captain => true).where('gameweek_in <= ? and (gameweek_out is null or gameweek_out > ?)', @match.gameweek, @match.gameweek).first.player
  end

  def away_captain
    PlayerTeamRelationship.where(:team_id => @away_team.id, :captain => true).where('gameweek_in <= ? and (gameweek_out is null or gameweek_out > ?)', @match.gameweek, @match.gameweek).first.player
  end
end
