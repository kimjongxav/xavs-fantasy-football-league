class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :transfers_remaining, default: 3
      t.string :properties # this will be a string in the style of json
      (1..38).to_a.map { |i| t.integer "points_in_gameweek_#{i}", default: 0 }

      t.timestamps
    end
  end
end
