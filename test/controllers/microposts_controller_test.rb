require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase

  def setup
    @micropost = microposts(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.all.count' do
      post :create, micropost: { content: "Lorem ipsum" }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when npt logged in" do
    assert_no_difference 'Micropost.all.count' do
      post :destroy, id: @micropost
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:test_user))
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.all.count' do
      delete :destroy, id: micropost
    end
    assert_redirected_to root_url
  end
end
