require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  def setup
    @player = Player.new(
      full_name: 'Lee Cattermole',
      common_name: 'Cattermole',
      position: 'MID',
      premier_league_team_id: 1,
      fantasy_football_id: 1,
    )
  end

  test 'should be valid' do
    assert @player.valid?
  end

  test 'full_name should be present' do
    @player.full_name = '     '
    assert_not @player.valid?
  end

  test 'common_name should be present' do
    @player.common_name = '     '
    assert_not @player.valid?
  end

  test 'position should be present' do
    @player.position = '     '
    assert_not @player.valid?
  end

  test 'premier_league_team_id should be present' do
    @player.premier_league_team_id = 0
    assert_not @player.valid?
  end
end
