class EventsController < ApplicationController
  before_action :set_event, only: [:reply, :edit, :update]

  before_action :authenticate_member!

  def reply
    @event.update_reply(current_member, params[:reply])
  end

  private
  def set_event
    @event = Event.find(params[:event_id] || params[:id])
  end
end
