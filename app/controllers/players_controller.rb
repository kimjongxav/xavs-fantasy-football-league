class PlayersController < ApplicationController
  before_action :logged_in_user, only: [:index]

  def index
    @players = Player.paginate(page: params[:page])
  end

  def show
    @player = Player.find(params[:id])
    @points = points
  end

  def new
  end

  def points
    (1..38).map do |gw|
      @player["points_in_gameweek_#{gw}"]
    end
  end
end
