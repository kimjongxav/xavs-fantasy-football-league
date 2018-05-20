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

  def sort_by_position(players)
    positions = {
      'GK' => 1,
      'DEF' => 2,
      'MID' => 3,
      'FWD' => 4,
    }
    players.sort_by do |player|
      positions[player.position]
    end
  end

  def total_player_points(player)
    JSON.parse(player.gameweek_points).values.inject(:+)
  end

  helper_method :total_player_points
end
