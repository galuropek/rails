require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:test_user)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    # incorrect micropost
    assert_no_difference 'Micropost.all.count' do
      post microposts_path, micropost: { content: "" }
    end
    assert_select 'div#error_explanation'
    # correct micropost
    content = "This is correct micropost"
    assert_difference 'Micropost.all.count', 1 do
      post microposts_path, micropost: { content: content }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # remove micropost
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.all.count', -1 do
      delete micropost_path(first_micropost)
    end
    # move to other user
    get user_path(users(:test_user_2))
    assert_select 'a', text: 'delete', count: 0
  end
end
