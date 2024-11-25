class CommentsController < ApplicationController
  def index
    @comments = Comment.where(parent_id: nil).includes(:replies)
  end
end
