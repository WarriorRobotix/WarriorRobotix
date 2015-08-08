class EventsController < ApplicationController
  before_action :set_event, only: [:confirm, :maybe, :decline]

  before_action :authenticate_member!

  def confirm
    @event.update_reply(current_member, :confirmed)
    redirect_back
  end

  def maybe
    @event.update_reply(current_member, :maybe)
    redirect_back
  end

  def decline
    @event.update_reply(current_member, :declined)
    redirect_back
  end

  private
  def set_event
    @event = Event.find(params[:event_id])
  end
end
