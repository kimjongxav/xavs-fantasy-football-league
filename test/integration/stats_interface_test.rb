require 'test_helper'

class StatsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:frodo)
    @other_user = users(:bilbo)
    @user.follow(@other_user)
  end

  test 'stats interface' do
    log_in_as(@user)
    get root_path
    assert_select 'a[href=?]', following_user_path(@user)
    assert_select 'a[href=?]', followers_user_path(@user)
    assert_select 'aside>section.stats>div.stats'
    assert_select 'a>strong', count: 2
    assert_select 'strong#following', text: @user.following.count.to_s
    assert_select 'strong#followers', text: @user.followers.count.to_s
  end
end
