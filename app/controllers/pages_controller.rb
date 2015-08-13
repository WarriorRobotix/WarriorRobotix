class PagesController < ApplicationController
  before_action :authenticate_admin!, only: [:attend]
  def home
    if member_signed_in?
      redirect_to posts_path
    end
  end
  def attend
    @checkedin = Array.new
    @checkedout = Array.new
    current_date = DateTime.now
    Attendance.order(start_at: :asc).each do |f|
      attendance_date = f.start_at
      if !f.start_at.nil? && f.end_at.nil?
        if attendance_date.day == current_date.day && attendance_date.month == current_date.month && attendance_date.year == current_date.year
          @checkedin.push(f)
        end
      end
      if !f.start_at.nil? && !f.end_at.nil?
        if attendance_date.day == current_date.day && attendance_date.month == current_date.month && attendance_date.year == current_date.year
          @checkedout.push(f)
        end
      end
    end
    @recieveMessage = params[:message]
    @message = ""
    if @recieveMessage == 0
      @message = "Can not find anyone with the given Student Number!"
    elsif @recieveMessage == 1
      @message = "You have been Checked In..."
    elsif @recieveMessage == 2
      @message = "You have been Checked Out..."
    elsif @recieveMessage == 3
      @message = "You have already Checked In and Out Today!"
    end
  end
end
