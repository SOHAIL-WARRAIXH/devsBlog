class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  validates :recipient, :actor, :notifiable, :action, presence: true

  scope :unread, -> { where(read_at: nil) }

  after_create_commit -> { broadcast_append_to recipient, partial: "notifications/notification", target: "notifications" }
end
