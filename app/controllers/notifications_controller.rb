class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.order(created_at: :desc)
    @unread_notifications = @notifications.unread
    @unread_notifications.update_all(read_at: Time.current)
  end
end
