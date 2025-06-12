module ApplicationHelper
  def unread_messages_count
    if user_signed_in?
      current_user.conversations.joins(:messages).where.not(messages: { user_id: current_user.id }).where(messages: { read: false }).distinct.count
    else
      0
    end
  end

  def unread_notifications_count
    if user_signed_in?
      current_user.notifications.unread.count
    else
      0
    end
  end
end
