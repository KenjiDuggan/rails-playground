require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email_address: "kenji.duggan@shopify.com", password: "12345")
    @post = Post.create!(title: "Test Post", body: "This is a test post", user: @user)
    @comment = Comment.new(body: "This is a test comment", user: @user, post: @post)
  end

  test "should be valid with valid attributes" do
    assert @comment.valid?
  end

  test "should require a body" do
    @comment.body = nil
    assert_not @comment.valid?
    assert_includes @comment.errors[:body], "can't be blank"
  end

  test "should belong to a user" do
    @comment.user = nil
    assert_not @comment.valid?
    assert_includes @comment.errors[:user], "must exist"
  end

  test "should belong to a post" do
    @comment.post = nil
    assert_not @comment.valid?
    assert_includes @comment.errors[:post], "must exist"
  end

  test "can have a parent comment" do
    parent_comment = Comment.create!(body: "Parent comment", user: @user, post: @post)
    @comment.parent = parent_comment
    assert @comment.valid?
  end

  test "can have replies" do
    @comment.save!
    reply = @comment.replies.create!(body: "This is a reply", user: @user, post: @post)
    assert_includes @comment.replies, reply
  end

  test "parent must exist for replies" do
    @comment.parent_id = 99999
    assert_not @comment.valid?
    assert_includes @comment.errors[:parent], "must exist for replies"
  end

  test "should validate body length" do
    @comment.body = "a" * 501
    assert_not @comment.valid?
    assert_includes @comment.errors[:body], "is too long (maximum is 500 characters)"

    @comment.body = ""
    assert_not @comment.valid?
    assert_includes @comment.errors[:body], "is too short (minimum is 1 character)"
  end

  test "should enforce uniqueness of body per user per post" do
    @comment.save!
    duplicate_comment = @comment.dup
    assert_not duplicate_comment.valid?
    assert_includes duplicate_comment.errors[:body], "has already been taken for this post by this user"
  end

  test "should not allow a comment to be its own ancestor" do
    @comment.save!
    @comment.parent = @comment
    assert_not @comment.valid?
    assert_includes @comment.errors[:parent], "cannot be its own ancestor"
  end

  test "should allow different users to post the same comment on the same post" do
    @comment.save!
    another_user = User.create!(email_address: "another.user@shopify.com", password: "67890")
    another_comment = Comment.new(body: @comment.body, user: another_user, post: @post)
    assert another_comment.valid?
  end

  test "should handle concurrent comment creation" do
    comment1 = Comment.new(body: "Concurrent comment", user: @user, post: @post)
    comment2 = Comment.new(body: "Concurrent comment", user: @user, post: @post)

    assert_difference('Comment.count', 1) do
      comment1.save
      comment2.save rescue ActiveRecord::RecordNotUnique
    end
  end
end
