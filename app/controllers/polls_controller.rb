class PollsController < ApplicationController
  before_action :set_poll, only: [:vote, :edit, :update, :show]
  skip_before_action :authenticate_admin!, only: [:vote]
  before_action :authenticate_member!

  # GET /polls/new
  def new
    @poll = Poll.new
  end

  # GET /polls/1/edit
  def edit
  end

  # POST /polls
  # POST /polls.json
  def create
    @poll = Poll.new(poll_params)
    @poll.author = current_member
    if @poll.limited? && params[:teams].present?
      @poll.team_ids = params[:teams].keys
    end

    respond_to do |format|
      if @poll.save
        if @poll.email_notification
          PostMailer.poll_email(@poll, true).deliver_later
        end
        format.html { try_redirect_back { redirect_to @poll, notice: 'Poll was successfully created.' } }
        format.json { render :show, status: :created, location: @poll }
      else
        format.html { render :new }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /polls/1
  # PATCH/PUT /polls/1.json
  def update
    respond_to do |format|
      if (params[:poll][:restriction] == "limited" || (params[:poll][:restriction].nil? && @poll.limited?)) && params[:teams].present?
        @poll.team_ids = params[:teams].keys
      end
      if @poll.update(poll_params)
        if @poll.email_notification
          PostMailer.poll_email(@poll, false).deliver_later
        end
        format.html { try_redirect_back { redirect_to @poll, notice: 'Poll was successfully updated.' } }
        format.json { render :show, status: :ok, location: @poll }
      else
        format.html { render :edit }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /polls/1/vote (js only)
  def vote
    if @poll[:restriction] > max_restriction
      unless @poll.team_ids.include?(current_member.team_id)
        raise Forbidden
      end
    end

    voted_ballots = Ballot.joins(:option).where(member_id: current_member.id, options: { poll_id: @poll.id }).pluck(:option_id)
    vaild_option_ids = Set.new(@poll.option_ids)
    has_voted = !voted_ballots.empty?

    if (has_voted && !@poll.ballots_changeable)
      @error = "Ballot is unchangeable"
      return
    end

    if @poll.multiple_choices
      new_ballots = Set.new(params[:vote].try(:keys).map(&:to_i) || [])
      voted_ballots = Set.new(voted_ballots)

      unless vaild_option_ids.superset?(new_ballots)
        @error = "One or more invalid ballots"
        return
      end

      common = voted_ballots & new_ballots

      new_ballots -= common
      new_ballots.to_a.each do |option_id|
        Ballot.create!(member: current_member, option_id: option_id)
      end

      remove_ballots = voted_ballots - common
      Ballot.where(member: current_member, option_id: remove_ballots.to_a).destroy_all
    else
      new_ballot = params[:vote].to_i
      old_ballot = voted_ballots[0]

      unless vaild_option_ids.include?(new_ballot)
        @error = "Invalid ballot"
        return
      end

      unless old_ballot.nil?
        ballout = Ballot.where(member: current_member, option_id: old_ballot).take
      end
      ballout ||= Ballot.new(member: current_member)
      ballout.option_id = new_ballot
      ballout.save
    end
  end

  private
  def set_poll
    @poll = Poll.find(params[:poll_id] || params[:id])
  end

  def poll_params
    params.require(:poll).permit(:title, :description, :restriction, :email_notification, :multiple_choices, :maximum_choices, :ballots_changeable, :ballots_privacy, options_attributes: [:id, :description, :_destroy])
  end
end
