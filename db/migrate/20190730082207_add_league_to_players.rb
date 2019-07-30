class AddLeagueToPlayers < ActiveRecord::Migration[5.1]
  def up
    add_column :players, :league_id, :integer
  end

  def down
    remove_column :players, :league_id
  end
end
