require 'simplecov'
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def sign_in_as_admin
    admin = members(:admin)
    post "/signin", params: { identifier: admin.student_number, password: '123456' }
  end

  def sign_in_as_member
    member = members(:member)
    post "/signin", params: { identifier: member.student_number, password: '123456' }
  end
end
