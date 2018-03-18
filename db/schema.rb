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

ActiveRecord::Schema.define(version: 20180318191856) do

  create_table "bids", force: :cascade do |t|
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gameweek"], name: "index_matches_on_gameweek"
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
    t.integer "points_in_gameweek_1", default: 0
    t.integer "points_in_gameweek_2", default: 0
    t.integer "points_in_gameweek_3", default: 0
    t.integer "points_in_gameweek_4", default: 0
    t.integer "points_in_gameweek_5", default: 0
    t.integer "points_in_gameweek_6", default: 0
    t.integer "points_in_gameweek_7", default: 0
    t.integer "points_in_gameweek_8", default: 0
    t.integer "points_in_gameweek_9", default: 0
    t.integer "points_in_gameweek_10", default: 0
    t.integer "points_in_gameweek_11", default: 0
    t.integer "points_in_gameweek_12", default: 0
    t.integer "points_in_gameweek_13", default: 0
    t.integer "points_in_gameweek_14", default: 0
    t.integer "points_in_gameweek_15", default: 0
    t.integer "points_in_gameweek_16", default: 0
    t.integer "points_in_gameweek_17", default: 0
    t.integer "points_in_gameweek_18", default: 0
    t.integer "points_in_gameweek_19", default: 0
    t.integer "points_in_gameweek_20", default: 0
    t.integer "points_in_gameweek_21", default: 0
    t.integer "points_in_gameweek_22", default: 0
    t.integer "points_in_gameweek_23", default: 0
    t.integer "points_in_gameweek_24", default: 0
    t.integer "points_in_gameweek_25", default: 0
    t.integer "points_in_gameweek_26", default: 0
    t.integer "points_in_gameweek_27", default: 0
    t.integer "points_in_gameweek_28", default: 0
    t.integer "points_in_gameweek_29", default: 0
    t.integer "points_in_gameweek_30", default: 0
    t.integer "points_in_gameweek_31", default: 0
    t.integer "points_in_gameweek_32", default: 0
    t.integer "points_in_gameweek_33", default: 0
    t.integer "points_in_gameweek_34", default: 0
    t.integer "points_in_gameweek_35", default: 0
    t.integer "points_in_gameweek_36", default: 0
    t.integer "points_in_gameweek_37", default: 0
    t.integer "points_in_gameweek_38", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "premier_league_team_id"
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
    t.integer "transfers_remaining", default: 3
    t.string "properties"
    t.integer "points_in_gameweek_1", default: 0
    t.integer "points_in_gameweek_2", default: 0
    t.integer "points_in_gameweek_3", default: 0
    t.integer "points_in_gameweek_4", default: 0
    t.integer "points_in_gameweek_5", default: 0
    t.integer "points_in_gameweek_6", default: 0
    t.integer "points_in_gameweek_7", default: 0
    t.integer "points_in_gameweek_8", default: 0
    t.integer "points_in_gameweek_9", default: 0
    t.integer "points_in_gameweek_10", default: 0
    t.integer "points_in_gameweek_11", default: 0
    t.integer "points_in_gameweek_12", default: 0
    t.integer "points_in_gameweek_13", default: 0
    t.integer "points_in_gameweek_14", default: 0
    t.integer "points_in_gameweek_15", default: 0
    t.integer "points_in_gameweek_16", default: 0
    t.integer "points_in_gameweek_17", default: 0
    t.integer "points_in_gameweek_18", default: 0
    t.integer "points_in_gameweek_19", default: 0
    t.integer "points_in_gameweek_20", default: 0
    t.integer "points_in_gameweek_21", default: 0
    t.integer "points_in_gameweek_22", default: 0
    t.integer "points_in_gameweek_23", default: 0
    t.integer "points_in_gameweek_24", default: 0
    t.integer "points_in_gameweek_25", default: 0
    t.integer "points_in_gameweek_26", default: 0
    t.integer "points_in_gameweek_27", default: 0
    t.integer "points_in_gameweek_28", default: 0
    t.integer "points_in_gameweek_29", default: 0
    t.integer "points_in_gameweek_30", default: 0
    t.integer "points_in_gameweek_31", default: 0
    t.integer "points_in_gameweek_32", default: 0
    t.integer "points_in_gameweek_33", default: 0
    t.integer "points_in_gameweek_34", default: 0
    t.integer "points_in_gameweek_35", default: 0
    t.integer "points_in_gameweek_36", default: 0
    t.integer "points_in_gameweek_37", default: 0
    t.integer "points_in_gameweek_38", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "league_id"
    t.index ["league_id"], name: "index_teams_on_league_id"
    t.index ["user_id"], name: "index_teams_on_user_id"
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
