class EventsController < ApplicationController
  before_action :set_event, only: [:reply]

  before_action :authenticate_member!

  def reply
    @event.update_reply(current_member, params[:reply])
    respond_to do |format|
      format.html { render plain: params[:reply] }
      format.json { render plain: params[:reply] }
      format.js   { render :reply }
    end

  end

  private
  def set_event
    @event = Event.find(params[:event_id])
  end
end
