# add table users
class CreateAllTables < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :remember_digest
      t.boolean :admin, default: false
      t.string :activation_digest
      t.boolean :activated, default: false
      t.datetime :activated_at
      t.string :reset_digest
      t.datetime :reset_sent_at
      t.string :initials

      t.timestamps
    end
    add_index :users, :email, unique: true

    create_table :teams do |t|
      t.string :name
      t.integer :transfers_remaining, default: 3
      t.string :properties # this will be a string in the style of json
      (1..38).to_a.map { |i| t.integer "points_in_gameweek_#{i}", default: 0 }

      t.timestamps
    end

    create_table :players do |t|
      t.integer :fantasy_football_id
      t.string :full_name
      t.string :common_name
      t.string :position
      (1..38).to_a.map { |i| t.integer "points_in_gameweek_#{i}", default: 0 }

      t.timestamps
    end
    add_index :players, :fantasy_football_id
    add_index :players, :common_name

    create_table :leagues do |t|
      t.string :season
      t.string :name

      t.timestamps
    end
    add_reference :teams, :user, foreign_key: true
    add_reference :teams, :league, foreign_key: true

    create_table :bids do |t|
      t.integer :value

      t.timestamps
    end
    add_reference :bids, :player, foreign_key: true
    add_reference :bids, :user, foreign_key: true

    create_table :matches do |t|
      t.integer :home_score
      t.integer :away_score
      t.integer :gameweek

      t.timestamps
    end
    add_index :matches, :gameweek
    add_reference :matches, :team, foreign_key: true
    add_reference :matches, :league, foreign_key: true

    create_table :premier_league_teams do |t|
      t.string :name
      t.string :short_name

      t.timestamps
    end
    add_reference :players, :premier_league_team, foreign_key: true, index: true
  end
end
