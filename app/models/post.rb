class Post < ApplicationRecord
  validates :title, uniqueness: { case_sensitive: false }, presence: true
  validates :user, presence: true
  before_validation :unique_title_on_update, on: :update
  has_many :comments, class_name: "Comment", foreign_key: :post_id, dependent: :destroy

  belongs_to :user

  private

  def unique_title_on_update
    if !title_changed? && Post.where(title: title).count > 1
      self.title = "#{title}-#{SecureRandom.hex(4)}"
    end
  end
end
