class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :like, :unlike]
  load_and_authorize_resource

  def index
    @posts = Post.latest.with_user.with_comments.with_likes.page(params[:page])
  end

  def show
    @comment = Comment.new
    @comments = @post.comments.latest.with_user.page(params[:page])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: 'Post was successfully deleted.'
  end

  def like
    @like = @post.likes.create(user: current_user)
    respond_to do |format|
      if @like.persisted?
        format.turbo_stream
        format.html { redirect_to @post }
      else
        format.html { redirect_to @post, alert: 'Error liking post.' }
      end
    end
  end

  def unlike
    @like = @post.likes.find_by(user: current_user)
    if @like&.destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @post }
      end
    else
      redirect_to @post, alert: 'Error unliking post.'
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(
      :caption,
      images: []
    )
  end
end
