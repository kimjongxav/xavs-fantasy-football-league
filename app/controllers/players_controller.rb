class PlayersController < ApplicationController
  before_action :logged_in_user, only: [:index]

  def index
    @players = Player.paginate(page: params[:page])
  end

  def show
    @player = Player.find(params[:id])
  end

  def new
  end
end
