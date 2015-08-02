class Attendance < ActiveRecord::Base
  enum status: [:invited, :confirmed, :maybe, :declined, :attending, :attended, :skipped]
end
