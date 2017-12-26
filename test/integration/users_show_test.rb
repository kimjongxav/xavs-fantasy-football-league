require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:frodo)
    @unactivated = users(:gollum)
  end

  test 'show activated user' do
    log_in_as(@user)
    get user_path(@user.id)
    assert_template 'users/show'
  end

  test 'show unactivated user' do
    log_in_as(@user)
    get user_path(@unactivated.id)
    assert_redirected_to root_url
  end
end
