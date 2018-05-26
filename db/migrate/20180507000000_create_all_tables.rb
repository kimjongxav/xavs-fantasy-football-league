# add table users
class CreateAllTables < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :remember_digest
      t.boolean :admin, :default => false
      t.string :activation_digest
      t.boolean :activated, :default => false
      t.datetime :activated_at
      t.string :reset_digest
      t.datetime :reset_sent_at
      t.string :initials

      t.timestamps
    end
    add_index :users, :email, :unique => true

    create_table :teams do |t|
      t.string :name
      t.integer :transfers_remaining, :default => 3
      t.string :properties # this will be a string in the style of json
      t.string :gameweek_points # this will be a string in the style of json

      t.timestamps
    end

    create_table :players do |t|
      t.string :full_name
      t.string :common_name
      t.string :position
      t.string :gameweek_points # this will be a string in the style of json

      t.timestamps
    end
    add_index :players, :common_name

    create_table :leagues do |t|
      t.string :season
      t.string :name

      t.timestamps
    end
    add_reference :teams, :user, :foreign_key => true
    add_reference :teams, :league, :foreign_key => true

    create_table :bids do |t|
      t.integer :value
      t.string :window
      t.integer :round

      t.timestamps
    end
    add_reference :bids, :player, :foreign_key => true
    add_reference :bids, :team, :foreign_key => true

    create_table :matches do |t|
      t.integer :home_team_id
      t.integer :away_team_id
      t.integer :gameweek
      t.integer :home_score, :default => 0
      t.integer :away_score, :default => 0
      t.integer :home_points, :default => 0
      t.integer :away_points, :default => 0
      t.boolean :played, :default => false

      t.timestamps
    end
    add_index :matches, :gameweek
    add_reference :matches, :league, :foreign_key => true

    create_table :premier_league_teams do |t|
      t.string :name
      t.string :short_name

      t.timestamps
    end
    add_reference :players, :premier_league_team, :foreign_key => true, :index => true

    create_table :player_team_relationships do |t|
      t.integer :player_id
      t.integer :team_id
      t.integer :gameweek_in
      t.integer :gameweek_out
      t.boolean :captain_in
      t.boolean :captain_out

      t.timestamps
    end
  end
end
