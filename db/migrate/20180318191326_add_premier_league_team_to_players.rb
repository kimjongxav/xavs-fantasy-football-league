class AddPremierLeagueTeamToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_reference :players, :premier_league_team, foreign_key: true, index: true
  end
end
