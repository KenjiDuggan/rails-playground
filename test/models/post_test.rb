require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "should not allow duplicate titles on create" do
    Post.create!(title: 'Unique Title')
    duplicate_post = Post.new(title: 'Unique Title')

    assert_not duplicate_post.valid?
    assert_includes duplicate_post.errors[:title], 'has already been taken'
  end

  test "should not allow duplicate titles on create with different case" do
    Post.create!(title: 'Unique Title')
    duplicate_post = Post.new(title: 'unique title')

    assert_not duplicate_post.valid?
    assert_includes duplicate_post.errors[:title], 'has already been taken'
  end

  test "should not allow duplicate titles on update if title is changed" do
    existing_post = Post.create!(title: 'Existing Title')
    another_post = Post.create!(title: 'Another Title')
    another_post.title = 'Existing Title'

    assert_not another_post.valid?
    assert_includes another_post.errors[:title], 'has already been taken'
  end

  test "should append unique string to title if not changed and duplicate exists" do
    existing_post = Post.create!(title: 'Existing Title')
    duplicate_post = Post.new(title: 'Existing Title')
    duplicate_post.save(validate: false)
    duplicate_post.update(body: 'Updated content')

    assert_not_equal 'Existing Title', duplicate_post.title
    assert_match /^Existing Title-\h{8}$/, duplicate_post.title
  end

  test "should not change title if it is already unique on update" do
    post = Post.create!(title: 'Unique Title')
    post.update(body: 'Updated content')

    assert_equal 'Unique Title', post.title
  end

  test "should add error if title is empty" do
    post = Post.new(title: '')

    assert_not post.valid?
    assert_includes post.errors[:title], "can't be blank"
  end

  test "should add error if title is nil" do
    post = Post.new(title: nil)

    assert_not post.valid?
    assert_includes post.errors[:title], "can't be blank"
  end

  test "should change the title if title has changed and duplicate exists" do
    post = Post.create(title:"Star Wars")
    new_post = Post.new(title: "Star Wars Two")
    new_post.save(validate: false)
    another_post = Post.new(title: "Star Wars")
    another_post.save(validate: false)

    another_post.update(body: "something")

    new_post.update(title: "Star Wars")

    assert new_post.invalid?
    assert_includes new_post.errors[:title], 'has already been taken'
  end
end
