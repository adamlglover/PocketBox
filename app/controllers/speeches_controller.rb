class SpeechesController < ApplicationController
  def create
    @room = Room.find(params[:code])
    if @room
      @speech = @room.speeches.create(speech_params)
      message = {
        room_id: @room.id.to_s,
        url: @speech.speech_doc.url(:original, false),
        name: @speech.speech_doc.original_filename.gsub('.docx', '').gsub('_', ' ')
      }
      WebsocketRails[:speeches].trigger(:new_speech, message) if @speech
      redirect_to room_path(code: @room.code)
    else
      redirect_to root_path
    end
  end

  private

  def speech_params
    params.require(:speech).permit(:speech_doc)
  end
end
