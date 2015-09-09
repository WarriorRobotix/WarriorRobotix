class PagesController < ApplicationController
  skip_before_action :authenticate_admin!, only: [:home, :contact, :contact_message, :vex, :skills, :teams, :about_us]
  def home
    set_meta_tags_for_home
    @show_side_buttons = true
  end

  def vex
  end

  def skills
  end

  def teams
  end

  def about_us
  end

  def contact
    @message = Hash.new
    @show_side_buttons = true
  end

  def contact_message
    @message = params.require(:message).permit(:full_name, :email, :phone_number, :body).to_h.symbolize_keys!
    if verify_recaptcha
      if @message[:full_name].blank?
        flash.now[:alert] = 'Please tell us your name.'
        @message[:full_name] = 'Anonymous'
      elsif @message[:body].blank?
        flash.now[:alert] = 'Message can\'t be blank.'
      else
        @message.merge!(ip: request.remote_ip.to_s, timestamp: Time.zone.now.to_s)
        ContactMailer.contact_us_email(@message).deliver_later
        flash[:notice] =  "Your message has successfully sent to us"
        redirect_to contact_path
        return
      end
    end
    render :contact
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
  private
  def set_meta_tags_for_home
    set_meta_tags og: {
      title:    'Warrior Robotix',
      type:     'website',
      url:      'http://4659warriors.com',
      description: 'Team 4659 Warrior Robotix is the robotics club of Port Credit Secondary School in Mississauga. We participate in Vex, Skills Ontario and other robotics competitions.',
      image:    [{
        _: 'http://4659warriors.com/assets/pages/home/slider_image_0.jpg',
        type: 'image/jpeg',
        width: 1400,
        height: 700,
      },
      {
        _: 'http://4659warriors.com/assets/pages/home/slider_image_3.jpg',
        type: 'image/jpeg',
        width: 1400,
        height: 700,
      }]
    },  twitter: {
      site: '@WarriorRobotix',
      card: 'summary_large_image',
      description: 'Team 4659 Warrior Robotix is the robotics club of Port Credit Secondary School in Mississauga. We participate in Vex, Skills Ontario and other robotics competitions.',
      image: 'http://4659warriors.com/assets/pages/home/slider_image_0.jpg'
    }
  end
end
