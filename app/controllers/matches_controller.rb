class MatchesController < ApplicationController
  before_action :logged_in_user, only: [:index]

  def index
    @matches = Match.paginate(page: params[:page])
  end

  def show
    @match = Match.find(params[:id])
  end

  def new
  end
end
