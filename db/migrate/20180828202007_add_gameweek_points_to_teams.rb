class AddGameweekPointsToTeams < ActiveRecord::Migration[5.1]
  def up
    add_column :teams, :gameweek_points, :text
  end
  def down
    remove_column :teams, :gameweek_points
  end
end
