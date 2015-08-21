class RegistrationForm
  class << self
    def open?
      @open ||= GlobalVar.fetch(:registration_form_open, default: false)
    end

    def toggle(open)
      @open = GlobalVar[:registration_form_open] = open
    end
  end
end
