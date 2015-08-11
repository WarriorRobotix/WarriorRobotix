class PollsController < ApplicationController
  before_action :set_poll, only: [:reply]
  before_action :authenticate_member!

  def reply
    voted_ballots = Ballot.joins(:option).where(member_id: current_member.id, options: { poll_id: @poll.id }).pluck(:option_id)
    vaild_option_ids = Set.new(@poll.option_ids)
    has_voted = !voted_ballots.empty?

    if (has_voted && !@poll.ballots_changeable)
      @error = "Ballot is unchangeable"
      return
    end
    
    if @poll.multiple_choices
      new_ballots = Set.new(params[:reply].try(:keys).map(&:to_i) || [])
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
      new_ballot = params[:reply]
      old_ballot = voted_ballots[0]

      unless vaild_option_ids.include?(new_ballot)
        @error = "Invalid ballot"
        return
      end

      unless old_ballot.nil?
        ballout = Ballout.new(member: current_member)
      else
        ballout = Ballout.where(member: current_member, option_id: old_ballot).take
      end
      ballout.option_id = new_ballot
      ballout.save
    end
  end

  private
  def set_poll
    @poll = Poll.find(params[:poll_id])
  end
end
