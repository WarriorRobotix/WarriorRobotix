class EventsController < ApplicationController
  before_action :set_event, only: [:reply, :edit, :update, :show]
  skip_before_action :authenticate_admin!, only: [:reply]
  before_action :authenticate_member!

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.author = current_member

    if start_at_params = params[:event][:start_at]
      @event.start_at = "#{start_at_params[:date]} #{start_at_params[:hour]}:#{start_at_params[:minute]}"
    end

    if end_at_params = params[:event][:end_at]
      @event.end_at = "#{end_at_params[:date]} #{end_at_params[:hour]}:#{end_at_params[:minute]}"
    end

    respond_to do |format|
      if @event.save
        if @event.email_notification
          PostMailer.event_email(@event, true).deliver_later
        end
        format.html { try_redirect_back { redirect_to @event, notice: 'Event was successfully created.' } }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update

    if start_at_params = params[:event][:start_at]
      @event.start_at = "#{start_at_params[:date]} #{start_at_params[:hour]}:#{start_at_params[:minute]}"
    end

    if end_at_params = params[:event][:end_at]
      @event.end_at = "#{end_at_params[:date]} #{end_at_params[:hour]}:#{end_at_params[:minute]}"
    end

    respond_to do |format|
      if @event.update(event_params)
        if @event.email_notification
          PostMailer.event_email(@event, false).deliver_later
        end
        format.html { try_redirect_back { redirect_to @event, notice: 'Event was successfully updated.' } }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def reply
    @event.update_reply(current_member, params[:reply])
  end

  private
  def set_event
    @event = Event.find(params[:event_id] || params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :restriction, :email_notification)
  end
end
