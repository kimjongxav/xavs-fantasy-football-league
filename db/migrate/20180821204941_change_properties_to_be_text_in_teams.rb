class ChangePropertiesToBeTextInTeams < ActiveRecord::Migration[5.1]
  def up
    change_column :teams, :properties, :text
    change_column :teams, :gameweek_scores, :text
    change_column :players, :gameweek_points, :text
  end

  def down
    change_column :teams, :properties, :string
    change_column :teams, :gameweek_scores, :string
    change_column :players, :gameweek_points, :string
  end
end
