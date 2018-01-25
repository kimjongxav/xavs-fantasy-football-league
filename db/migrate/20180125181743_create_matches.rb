class CreateMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :matches do |t|
      t.integer :home_score
      t.integer :away_score
      t.integer :gameweek
      t.references :team, foreign_key: true
      t.references :league, foreign_key: true

      t.timestamps
    end
    add_index :matches, :team_id
    add_index :matches, :league_id
    add_index :matches, :gameweek
  end
end
