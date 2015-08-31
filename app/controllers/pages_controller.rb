class PagesController < ApplicationController
  before_action :authenticate_admin!, only: [:attend]
  def home
    @show_side_buttons = true
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
  end
end
