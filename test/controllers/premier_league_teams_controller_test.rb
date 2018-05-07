require 'test_helper'

class PremierLeagueTeamsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get premier_league_teams_new_url
    assert_response :success
  end

end
