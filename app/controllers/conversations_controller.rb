class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [:show]

  def index
    @conversations = Conversation.joins(:conversation_participants)
                                .where(conversation_participants: { user_id: current_user.id })
                                .includes(:messages, :participants)
                                .distinct
  end

  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages.order(created_at: :asc)
    @message = Message.new

    # Mark messages as read when viewing the conversation
    @conversation.messages
                .where.not(user_id: current_user.id)
                .unread
                .update_all(read: true)
  rescue ActiveRecord::RecordNotFound
    redirect_to conversations_path, alert: "Conversation not found"
  end

  def create
    if params[:username].present?
      other_user = User.find_by(username: params[:username])
      
      if other_user.nil?
        redirect_to conversations_path, alert: "User not found"
        return
      end

      if other_user == current_user
        redirect_to conversations_path, alert: "You cannot chat with yourself"
        return
      end

      # Find existing conversation or create new one
      @conversation = Conversation.between_users(current_user, other_user)

      if @conversation.new_record?
        if @conversation.save
          # Create initial message to establish the conversation
          @conversation.messages.create!(user: current_user, content: "Started a conversation")
        else
          redirect_to conversations_path, alert: "Failed to create conversation"
          return
        end
      end

      redirect_to conversation_path(@conversation)
    else
      redirect_to conversations_path, alert: "Please enter a username"
    end
  end

  private

  def set_conversation
    @conversation = Conversation.joins(:conversation_participants)
                               .where(conversation_participants: { user_id: current_user.id })
                               .find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to conversations_path, alert: "Conversation not found"
  end
end 