require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:frodo)
  end

  test 'unsuccessful edit' do
    get edit_user_path(@user)
    assert_template 'users/edit'
    assert_template 'users/_form'
    patch user_path(@user),
          params: {
            user: {
              name: '',
              email: 'foo@invalid',
              password: 'foo',
              password_confirmation: 'bar'
            }
          }
    assert_template 'users/edit'
    assert_select 'div#error_explanation' do
      assert_select 'li', 'Name can\'t be blank'
      assert_select 'li', 'Email is invalid'
      assert_select 'li', 'Password is too short (minimum is 6 characters)'
      assert_select 'li', 'Password confirmation doesn\'t match Password'
    end
    assert_select 'div.alert', 'The form contains 4 errors.'
    assert_select 'div.field_with_errors', 8
  end

  test 'successful edit' do
    get edit_user_path(@user)
    assert_template 'users/edit'
    assert_template 'users/_form'
    name = 'Foo Bar'
    email = 'foo@example.com'
    patch user_path(@user),
          params: {
            user: {
              name: name,
              email: email,
              password: '',
              password_confirmation: ''
            }
          }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end
