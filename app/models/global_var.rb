class GlobalVar < ApplicationRecord
  enum data_type: [:string, :integer, :boolean]

  def value
    if integer?
      self.integer_value
    elsif boolean?
      self.integer_value > 0
    else
      self.string_value
    end
  end

  def value=(new_val)
    if integer?
      self.integer_value = new_val
    elsif boolean?
      self.integer_value = new_val ? 1 : 0
    else
      self.string_value = new_val
    end
  end

  class << self
    def [](name)
      fetch(name)
    end

    def []=(name,value)
      set(name,value)
    end

    def fetch(name, options={})
      default = options[:default]

      if var = find_by(name: name).try(:value)
        var
      elsif !default.nil?
        default
      elsif block_given?
        set(name, yield)
      else
        nil
      end
    end

    def set(name, value, data_type=nil)
      var = find_by(name: name)
      if var.nil?
        var = self.new(name: name)
        var.data_type = data_types.include?(data_type) ? data_type : object_data_type(value)
      end
      var.value = value
      var.save
      var.value
    end

    private
    def object_data_type(object)
      case object
      when Integer
        'integer'
      when TrueClass, FalseClass
        'boolean'
      else
        'string'
      end
    end
  end
end
