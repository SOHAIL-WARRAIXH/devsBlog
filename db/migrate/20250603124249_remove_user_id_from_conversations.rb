class RemoveUserIdFromConversations < ActiveRecord::Migration[8.0]
  def change
    remove_reference :conversations, :user, foreign_key: true
  end
end
