class AddCommentsToPosts < ActiveRecord::Migration[8.0]
  def change
    add_reference :comments, :post, null: true, foreign_key: true
  end
end
