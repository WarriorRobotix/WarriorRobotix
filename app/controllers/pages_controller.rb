class PagesController < ApplicationController
  skip_before_action :authenticate_admin!, only: [:home]
  def home
    set_meta_tags og: {
      title:    'Home Page',
      type:     'website',
      url:      'http://4659warriors.com',
      image:    [{
        _: 'http://4659warriors.com/assets/pages/home/vex2015.jpg',
        type: 'image/jpeg',
        width: 400,
        height: 300,
      }]
    }
    @show_side_buttons = true
  end

  def attend
    @checkedin = Array.new
    @checkedout = Array.new
    current_date = DateTime.now
    Attendance.order(start_at: :asc).each do |f|
      if f.event_id.nil?
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
    @event_today = false
    @event_list = Array.new
    Post.all.each do |f|
      if f.type == "Event"
        if f.start_at.day == current_date.day && f.start_at.month == current_date.month && f.start_at.year == current_date.year
          @event_today = true
          @event_list.push(f)
        end
      end
    end
  end

  def event
    @event = Event.find(params[:id])
    @checkedin = Array.new
    @checkedout = Array.new
    current_date = DateTime.now
    Attendance.order(start_at: :asc).each do |f|
      if !f.event_id.nil?
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
end
