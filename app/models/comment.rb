class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :content, presence: true, length: { minimum: 2, maximum: 1000 }

  scope :latest, -> { order(created_at: :desc) }
  scope :with_user, -> { includes(:user) }

  after_create_commit :create_notification

  private

  def create_notification
    return if user == post.user # Don't notify if user comments on their own post

    Notification.create!(
      recipient: post.user,
      actor: user,
      notifiable: post,
      action: "commented on your post"
    )
  end
end
