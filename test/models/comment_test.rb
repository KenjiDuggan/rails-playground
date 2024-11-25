require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email_address: "kenji.duggan@shopify.com", password: "12345")
    @comment = Comment.new(body: "This is a test comment", user: @user)
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

  test "can have a parent comment" do
    parent_comment = Comment.create!(body: "Parent comment", user: @user)
    @comment.parent = parent_comment
    assert @comment.valid?
  end

  test "can have replies" do
    @comment.save!
    reply = @comment.replies.create!(body: "This is a reply", user: @user)
    assert_includes @comment.replies, reply
  end
end
