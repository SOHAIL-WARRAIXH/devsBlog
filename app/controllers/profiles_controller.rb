class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :set_user_for_show, only: [:show]
  before_action :set_current_user_for_edit_update, only: [:edit, :update]

  def show
    @posts = @user.posts.latest.with_comments.with_likes.page(params[:page])
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to profile_path, notice: 'Profile was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # def index
  #   if params[:username].present?
  #     @users = User.where("username ILIKE ?", "%#{params[:username]}%").page(params[:page])
  #   else
  #     @users = User.page(params[:page])
  #   end
  # end

  private

  def set_user_for_show
    @user = params[:id] ? User.find(params[:id]) : current_user
  end

  def set_current_user_for_edit_update
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :bio, :avatar)
  end
end
