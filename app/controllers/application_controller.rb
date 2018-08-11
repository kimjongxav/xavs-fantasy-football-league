class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end

  def total_player_points(player)
    JSON.parse(player.gameweek_points).values.inject(:+)
  end

  helper_method :total_player_points
end
