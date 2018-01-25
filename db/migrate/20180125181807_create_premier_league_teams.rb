class CreatePremierLeagueTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :premier_league_teams do |t|
      t.string :name
      t.string :short_name

      t.timestamps
    end
  end
end
