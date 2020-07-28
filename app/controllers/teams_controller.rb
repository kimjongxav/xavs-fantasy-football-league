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

  def charts
    sum = 0
    @gameweek_scores = Team.all.map do |team|
      {
        name: team.name,
        data: team.gameweek_scores.map do |k, v|
          k == 1 ? sum = 0 : sum
          [k.to_s, sum += v]
        end.to_h
      }
    end
  end

  def new
  end

  def gameweek
    resp = HTTParty.get('https://fantasy.premierleague.com/api/bootstrap-static/')

    first_unfinished_event = resp['events'].find{|e| e['finished'] == false}
    return 38 if first_unfinished_event.nil?

    first_unfinished_event['id']  end
end
