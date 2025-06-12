class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :conversation_participants, dependent: :destroy
  has_many :participants, through: :conversation_participants, source: :user

  validates :participants, presence: true, length: { minimum: 2, maximum: 2 }

  def other_participant(user)
    participants.where.not(id: user.id).first
  end

  def last_message
    messages.order(created_at: :desc).first
  end

  def self.between_users(user1, user2)
    # Find existing conversation between the two users
    conversation = joins(:conversation_participants)
      .where(conversation_participants: { user_id: [user1.id, user2.id] })
      .group('conversations.id')
      .having('COUNT(DISTINCT conversation_participants.user_id) = 2')
      .first

    # If no conversation exists, create a new one
    unless conversation
      conversation = new
      conversation.participants = [user1, user2]
      conversation.save! # Raise an error if save fails
    end

    conversation
  end
end
