class RegistrationForm
  class << self
    def open?
      GlobalVar.fetch(:registration_form_open, default: false)
    end

    def toggle(open_form)
      prev_state = GlobalVar[:registration_form_open]
      if prev_state != open_form
        if !open_form
          GlobalVar[:registration_form_open] = false
        elsif valid_registration_fields?
          GlobalVar[:registration_form_open] = true
        else
          prev_state
        end
      else
        prev_state
      end
    end

    def verify_registration_fields!(valid_member_fields = nil)
      new_val = self.open? && (valid_member_fields || RegistrationField.valid_member_fields?)
      self.toggle(new_val)
    end

    def valid_registration_fields?
      GlobalVar.fetch(:valid_registration_fields) do
        RegistrationField.valid_member_fields?
      end
    end
  end
end
