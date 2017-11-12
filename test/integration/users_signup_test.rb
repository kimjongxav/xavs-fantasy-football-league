require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name:  '',
          email: 'user@invalid',
          password:              'foo',
          password_confirmation: 'bar'
        }
      }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation' do
      assert_select 'li', 'Name can\'t be blank'
      assert_select 'li', 'Email is invalid'
      assert_select 'li', 'Password is too short (minimum is 6 characters)'
      assert_select 'li', 'Password confirmation doesn\'t match Password'
    end
    assert_select 'div.field_with_errors', 8
    assert_select 'form[action="/signup"]'
  end
  test 'valid signup information' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: {
          name:  'Fake McName',
          email: 'user@valid.com',
          password:              'great_password',
          password_confirmation: 'great_password'
        }
      }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert_select 'div.alert.alert-success', 'Welcome to the Sample App!'
    assert is_logged_in?
  end
end
