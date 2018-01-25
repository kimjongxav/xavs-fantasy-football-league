# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180125181918) do

  create_table "bids", force: :cascade do |t|
    t.integer "value"
    t.integer "team_id"
    t.integer "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_bids_on_player_id"
    t.index ["team_id"], name: "index_bids_on_team_id"
  end

  create_table "leagues", force: :cascade do |t|
    t.string "season"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matches", force: :cascade do |t|
    t.integer "home_score"
    t.integer "away_score"
    t.integer "gameweek"
    t.integer "team_id"
    t.integer "league_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gameweek"], name: "index_matches_on_gameweek"
    t.index ["league_id"], name: "index_matches_on_league_id"
    t.index ["team_id"], name: "index_matches_on_team_id"
  end

  create_table "player_team_relationships", force: :cascade do |t|
    t.integer "player_id"
    t.integer "team_id"
    t.integer "gameweek_in"
    t.integer "gameweek_out"
    t.boolean "captain_in"
    t.boolean "captain_out"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id", "team_id"], name: "index_player_team_relationships_on_player_id_and_team_id", unique: true
    t.index ["player_id"], name: "index_player_team_relationships_on_player_id"
    t.index ["team_id"], name: "index_player_team_relationships_on_team_id"
  end

  create_table "players", force: :cascade do |t|
    t.integer "fantasy_football_id"
    t.string "full_name"
    t.string "common_name"
    t.string "position"
    t.integer "premier_league_team_id"
    t.integer "points_in_gameweek_1"
    t.integer "points_in_gameweek_2"
    t.integer "points_in_gameweek_3"
    t.integer "points_in_gameweek_4"
    t.integer "points_in_gameweek_5"
    t.integer "points_in_gameweek_6"
    t.integer "points_in_gameweek_7"
    t.integer "points_in_gameweek_8"
    t.integer "points_in_gameweek_9"
    t.integer "points_in_gameweek_10"
    t.integer "points_in_gameweek_11"
    t.integer "points_in_gameweek_12"
    t.integer "points_in_gameweek_13"
    t.integer "points_in_gameweek_14"
    t.integer "points_in_gameweek_15"
    t.integer "points_in_gameweek_16"
    t.integer "points_in_gameweek_17"
    t.integer "points_in_gameweek_18"
    t.integer "points_in_gameweek_19"
    t.integer "points_in_gameweek_20"
    t.integer "points_in_gameweek_21"
    t.integer "points_in_gameweek_22"
    t.integer "points_in_gameweek_23"
    t.integer "points_in_gameweek_24"
    t.integer "points_in_gameweek_25"
    t.integer "points_in_gameweek_26"
    t.integer "points_in_gameweek_27"
    t.integer "points_in_gameweek_28"
    t.integer "points_in_gameweek_29"
    t.integer "points_in_gameweek_30"
    t.integer "points_in_gameweek_31"
    t.integer "points_in_gameweek_32"
    t.integer "points_in_gameweek_33"
    t.integer "points_in_gameweek_34"
    t.integer "points_in_gameweek_35"
    t.integer "points_in_gameweek_36"
    t.integer "points_in_gameweek_37"
    t.integer "points_in_gameweek_38"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["common_name"], name: "index_players_on_common_name"
    t.index ["fantasy_football_id"], name: "index_players_on_fantasy_football_id"
    t.index ["premier_league_team_id"], name: "index_players_on_premier_league_team_id"
  end

  create_table "premier_league_teams", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.integer "transfers_remaining"
    t.string "properties"
    t.integer "points_in_gameweek_1"
    t.integer "points_in_gameweek_2"
    t.integer "points_in_gameweek_3"
    t.integer "points_in_gameweek_4"
    t.integer "points_in_gameweek_5"
    t.integer "points_in_gameweek_6"
    t.integer "points_in_gameweek_7"
    t.integer "points_in_gameweek_8"
    t.integer "points_in_gameweek_9"
    t.integer "points_in_gameweek_10"
    t.integer "points_in_gameweek_11"
    t.integer "points_in_gameweek_12"
    t.integer "points_in_gameweek_13"
    t.integer "points_in_gameweek_14"
    t.integer "points_in_gameweek_15"
    t.integer "points_in_gameweek_16"
    t.integer "points_in_gameweek_17"
    t.integer "points_in_gameweek_18"
    t.integer "points_in_gameweek_19"
    t.integer "points_in_gameweek_20"
    t.integer "points_in_gameweek_21"
    t.integer "points_in_gameweek_22"
    t.integer "points_in_gameweek_23"
    t.integer "points_in_gameweek_24"
    t.integer "points_in_gameweek_25"
    t.integer "points_in_gameweek_26"
    t.integer "points_in_gameweek_27"
    t.integer "points_in_gameweek_28"
    t.integer "points_in_gameweek_29"
    t.integer "points_in_gameweek_30"
    t.integer "points_in_gameweek_31"
    t.integer "points_in_gameweek_32"
    t.integer "points_in_gameweek_33"
    t.integer "points_in_gameweek_34"
    t.integer "points_in_gameweek_35"
    t.integer "points_in_gameweek_36"
    t.integer "points_in_gameweek_37"
    t.integer "points_in_gameweek_38"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "initials"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
