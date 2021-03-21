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
end
