class RegistrationsController < ApplicationController
  def form
    @form = Hash.new
    unless RegistrationField.valid_member_fields?
      render :error
    end
  end

  def submit
    @member = Member.new(accepted: false)
    RegistrationField.all.to_a.each do |field|
      value = params[:form][field.title]
      if field.map_to.present?
        @member.send("#{field.map_to}=", value)
      else
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
    else
      @form = params[:form].to_unsafe_h
      render :form
    end
  end
end
