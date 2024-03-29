require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Ivan Ivanov", email: "ivanov@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  # email format validation

  test "email validation should accept valid address" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US_ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn nikita98@mail.ru]

    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid? "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid address" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]

    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  # email uniq validation

  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  # password validation

  test "password should have a min length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  # microposts

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  # ralationships

  test "should follow and unfollow a user" do
    user = users(:test_user)
    other_user = users(:test_user_2)
    assert_not user.following?(other_user)
    user.follow(other_user)
    assert user.following?(other_user)
    assert other_user.followers.include?(user)
    user.unfollow(other_user)
    assert_not user.following?(other_user)
  end

  # feeds
  test "feed should have the right posts" do
    test_user = users(:test_user)
    test_user_2 = users(:test_user_2)
    lana = users(:lana)
    # feed of follow user
    lana.microposts.each do |post_following|
      assert test_user.feed.include?(post_following)
    end
    # feed of current user
    test_user.microposts.each do |post_self|
      assert test_user.feed.include?(post_self)
    end
    # feed of unfollow user
    test_user_2.microposts.each do |post_unfollowed|
      assert_not test_user.feed.include?(post_unfollowed)
    end
  end
end
