class EventsController < ApplicationController
  before_action :set_event, only: [:reply, :edit, :update]

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

    respond_to do |format|
      if @evnet.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
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
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
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
    params.require(:event).permit(:title, :description, :start_at, :end_at, :restriction)
  end
end
