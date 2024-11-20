class Post < ApplicationRecord
  validates :title, uniqueness: { case_sensitive: false }, presence: true
  validates :user, presence: true
  before_validation :unique_title_on_update, on: :update

  belongs_to :user

  private

  def unique_title_on_update
    if !title_changed? && Post.where(title: title).count > 1
      self.title = "#{title}-#{SecureRandom.hex(4)}"
    end
  end
end
