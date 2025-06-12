class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation
  before_action :ensure_participant

  def create
    @message = @conversation.messages.build(message_params)
    @message.user = current_user

    if @message.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @conversation }
      end
    else
      respond_to do |format|
        format.turbo_stream { 
          render turbo_stream: turbo_stream.replace(
            "message_form", 
            partial: "messages/form", 
            locals: { conversation: @conversation, message: @message }
          ) 
        }
        format.html { redirect_to @conversation, alert: "Message could not be sent." }
      end
    end
  end

  def destroy
    @message = @conversation.messages.find(params[:id])
    @message.destroy if @message.user == current_user

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@message) }
      format.html { redirect_to @conversation }
    end
  end

  private

  def set_conversation
    @conversation = current_user.conversations.find(params[:conversation_id])
  end

  def ensure_participant
    unless @conversation.participants.include?(current_user)
      redirect_to conversations_path, alert: "You are not authorized to access this conversation."
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end 