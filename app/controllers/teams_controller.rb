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
    resp = HTTParty.get('https://fantasy.premierleague.com/api/bootstrap-static')
    if resp['events'].nil?
      return Gameweek.where("deadline_time_epoch < ?", Time.now.to_i).last.gameweek + 1
    end

    [resp['events'].find{|e| e['finished'] == false}['id'], 38].min
  end
end
