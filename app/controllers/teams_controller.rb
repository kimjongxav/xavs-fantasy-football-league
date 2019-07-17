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
    url = 'https://fantasy.premierleague.com/api/bootstrap-static'
    response = HTTParty.get(url)
    1 unless response
    body = JSON.parse(response.body)
    gameweek = body['current-event'] if response.ok?
    finished = body['events'].select { |e| e['id'] == 1 }.first['finished']
    return gameweek + 1 if finished
    gameweek
  end
end
