class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates :content, presence: true
  validates :user_id, presence: true
  validates :conversation_id, presence: true

  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }

  after_create_commit -> {
    broadcast_append_to(
      "conversation_#{conversation_id}",
      partial: "messages/message",
      locals: { message: self },
      target: "conversation_#{conversation_id}_messages"
    )
  }

  def mark_as_read!
    update(read: true)
  end

  def self.unread_count_for_user(user_id, conversation_id)
    where(conversation_id: conversation_id)
      .where.not(user_id: user_id)
      .unread
      .count
  end
end
