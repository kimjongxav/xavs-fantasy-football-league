class CreateMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :matches do |t|
      t.integer :home_score
      t.integer :away_score
      t.integer :gameweek

      add_foreign_key :matches, :teams
      add_foreign_key :matches, :leagues

      t.timestamps
    end
    add_index :matches, :gameweek
  end
end
