class AddLeagueToPlayers < ActiveRecord::Migration[5.1]
  def up
    add_column :players, :league, :integer
  end

  def down
    remove_column :players, :league
  end
end
