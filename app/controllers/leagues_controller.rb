class LeaguesController < ApplicationController
  before_action :logged_in_user, only: [:index]

  def index
    @leagues = League.paginate(page: params[:page])
  end

  def show
    @league = League.find(params[:id])
  end

  def new
  end
end
