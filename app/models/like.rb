class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user_id, uniqueness: { scope: :post_id, message: "has already liked this post" }

  after_create_commit :create_notification

  private

  def create_notification
    return if user == post.user # Don't notify if user likes their own post

    Notification.create!(
      recipient: post.user,
      actor: user,
      notifiable: post,
      action: "liked your post"
    )
  end
end
