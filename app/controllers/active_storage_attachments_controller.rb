class ActiveStorageAttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    attachment = ActiveStorage::Attachment.find(params[:id])
    attachment.purge # This deletes the file from storage and the record from the database
    redirect_back fallback_location: root_path, notice: "Image was successfully removed."
  end
end 