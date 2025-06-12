class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: [:destroy]
  load_and_authorize_resource

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("post_#{@post.id}_comments", partial: "comments/comment", locals: { comment: @comment }),
            turbo_stream.update("new_comment", partial: "comments/form", locals: { post: @post, comment: Comment.new })
          ]
        end
        format.html { redirect_to @post, notice: 'Comment was successfully added.' }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "new_comment",
            partial: "comments/form",
            locals: { post: @post, comment: @comment }
          )
        end
        format.html { redirect_to @post, alert: 'Error adding comment.' }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @comment.destroy
        format.turbo_stream { render turbo_stream: turbo_stream.remove(@comment) }
        format.html { redirect_to @post, notice: 'Comment was successfully deleted.' }
      else
        format.html { redirect_to @post, alert: 'Error deleting comment.' }
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
