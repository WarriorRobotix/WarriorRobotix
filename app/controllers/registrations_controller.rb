class RegistrationsController < ApplicationController
  skip_before_action :authenticate_admin!, only: [:form, :submit]
  def form
    @form = Hash.new
    unless RegistrationForm.open?
      render :error
      return
    end
    @old_member = params[:old].present?
    if @old_member
      render :old_member_form
    else
      render :form
    end
  end

  def submit
    @old_member = params[:old].present?
    @member = Member.new(accepted: false)
    if verify_recaptcha(:model => @member, :message => "There is an error with reCAPTCHA") && (params[:form][:allow_emails] == '1') && (params[:form][:agree_contract] == '1')
      @member.extra_info = @member.extra_info.merge("Old member" => (@old_member ? 'Yes' : 'No'), "Registration timestamp" => Time.zone.now, "Registration IP" => request.remote_ip)
      RegistrationField.all.to_a.each do |field|
        value = params[:form][field.title]
        if field.map_to.present?
          @member.send("#{field.map_to}=", value)
        elsif !@old_member
          value = nil if value.blank?
          if !field.input_value_valid?(value)
            @member.add_extra_info_field_error("\"#{field.title}\" field is invalid or blank")
          else
            @member.extra_info = @member.extra_info.merge(field.title => value.to_s)
          end
        end
      end
      if @member.save
        render :confirmation
      elsif @old_member
        @form = params[:form].to_unsafe_h
        render :old_member_form
      else
        @form = params[:form].to_unsafe_h
        render :form
      end
    else
      @member.errors.add(:base, 'You must agree to receive emails from Warrior Robotix') unless (params[:form][:allow_emails] == '1')
      @member.errors.add(:base, 'You and your parents must read over and agree the <a href="/register/contract">student/parent contract</a>'.html_safe) unless (params[:form][:agree_contract] == '1')
      if @old_member
        @form = params[:form].to_unsafe_h
        render :old_member_form
      else
        @form = params[:form].to_unsafe_h
        render :form
      end
    end
  end

  def toggle
    RegistrationForm.toggle(params[:closed].nil? || params[:closed] != '1')
  end
end
