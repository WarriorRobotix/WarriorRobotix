module AttendancesHelper
  def load_attendances_for_center
    members = Member.order(first_name: :ASC, last_name: :ASC).all.select(:id, :first_name, :last_name, :grade, :team_id)

    today = Time.zone.now
    today_attendances = Attendance.where(start_at: today.beginning_of_day..today.end_of_day).all

    today_attendance_ids = Set.new( today_attendances.map { |a| a.id } )

    @unchecked_members = []
    @unchecked_member_teams = Hash.new
  end
end
