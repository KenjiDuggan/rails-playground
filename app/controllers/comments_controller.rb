class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show edit update destroy]

  # GET /comments/1/edit
  def edit
  end

  # GET /comments/1
  def show
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      redirect_to @comment.post, notice: "Comment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    if @comment.destroy
      respond_to do |format|
        format.html { redirect_to @comment.post, status: :see_other, notice: "Comment was successfully deleted." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to @comment.post, alert: "Failed to delete the comment." }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:body)
  end
end
