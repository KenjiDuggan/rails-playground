class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy

  validates :body,
    presence: true,
    length: {
      minimum: 1,
      maximum: 500
    },
    uniqueness: {
      scope: [:user_id, :post_id],
      message: "has already been taken for this post by this user"
    }
  validate :parent_must_exist_for_replies
  validate :cannot_be_own_ancestor

  scope :top_level, -> { where(parent_id: nil) }

  private

  def parent_must_exist_for_replies
    if parent_id.present? && !Comment.exists?(parent_id)
      errors.add(:parent, "must exist for replies")
    end
  end

  def cannot_be_own_ancestor
    if parent == self
      errors.add(:parent, "cannot be its own ancestor")
    end
  end
end
