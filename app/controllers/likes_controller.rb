class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  load_and_authorize_resource

  def create
    @like = @post.likes.build(user: current_user)

    respond_to do |format|
      if @like.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("post_#{@post.id}_like_button", 
              partial: "likes/like_button", 
              locals: { post: @post }),
            turbo_stream.update("post_#{@post.id}_like_count", 
              partial: "likes/like_count", 
              locals: { post: @post })
          ]
        end
        format.html { redirect_to @post, notice: 'Post was successfully liked.' }
      else
        format.html { redirect_to @post, alert: 'Error liking post.' }
      end
    end
  end

  def destroy
    @like = @post.likes.find_by(user: current_user)
    
    respond_to do |format|
      if @like&.destroy
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("post_#{@post.id}_like_button", 
              partial: "likes/like_button", 
              locals: { post: @post }),
            turbo_stream.update("post_#{@post.id}_like_count", 
              partial: "likes/like_count", 
              locals: { post: @post })
          ]
        end
        format.html { redirect_to @post, notice: 'Post was successfully unliked.' }
      else
        format.html { redirect_to @post, alert: 'Error unliking post.' }
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
