class TeamsController < ApplicationController
  before_action :logged_in_user, :only => [:index]

  def index
    @teams = Team.paginate(:page => params[:page])
  end

  def show
    @team = Team.find(params[:id])
    @players = @team.sort_by_position(@team.current_players)
    @bids = @team.bids
    @gameweek = gameweek
  end

  def new
  end

  def gameweek
    Gameweek.where("deadline_time_epoch < ?", DateTime.now.to_i).order(:deadline_time_epoch).last[:gameweek]
  end
end
