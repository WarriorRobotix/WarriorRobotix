# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160417185406) do

  create_table "attendances", force: :cascade do |t|
    t.integer  "member_id",              null: false
    t.integer  "event_id"
    t.integer  "status",     default: 0, null: false
    t.integer  "reply",      default: 0, null: false
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "duration"
  end

  add_index "attendances", ["event_id"], name: "index_attendances_on_event_id"
  add_index "attendances", ["member_id"], name: "index_attendances_on_member_id"

  create_table "ballots", force: :cascade do |t|
    t.integer  "member_id"
    t.integer  "option_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ballots", ["option_id"], name: "index_ballots_on_option_id"

  create_table "competitions", force: :cascade do |t|
    t.string   "name",                             null: false
    t.text     "description"
    t.string   "location"
    t.string   "achievements"
    t.string   "cover_image_link"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "count_down",       default: false, null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "divisions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "global_vars", force: :cascade do |t|
    t.string  "name",                      null: false
    t.integer "data_type",     default: 0
    t.string  "string_value"
    t.integer "integer_value"
  end

  add_index "global_vars", ["name"], name: "index_global_vars_on_name"

  create_table "members", force: :cascade do |t|
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "first_name",                            null: false
    t.string   "last_name",                             null: false
    t.string   "title"
    t.string   "email",                                 null: false
    t.string   "student_number"
    t.integer  "grade"
    t.boolean  "accepted",              default: true,  null: false
    t.boolean  "admin",                 default: false, null: false
    t.integer  "graduated_year"
    t.string   "extra_info"
    t.string   "reset_password_digest"
    t.datetime "reset_password_at"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "team_id"
    t.boolean  "show_debug_profiler",   default: false, null: false
  end

  add_index "members", ["email"], name: "index_members_on_email", unique: true
  add_index "members", ["student_number"], name: "index_members_on_student_number"

  create_table "options", force: :cascade do |t|
    t.integer  "poll_id"
    t.integer  "ballots_count", default: 0, null: false
    t.string   "description"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "photo_locations", force: :cascade do |t|
    t.string   "page",                                  null: false
    t.string   "location",                              null: false
    t.boolean  "prefered_local",        default: false, null: false
    t.integer  "photo_id"
    t.integer  "dimension_restriction", default: 0,     null: false
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "photo_locations", ["page"], name: "index_photo_locations_on_page"

  create_table "photos", force: :cascade do |t|
    t.string   "name"
    t.string   "file"
    t.string   "external_link"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string   "type"
    t.string   "title"
    t.text     "description"
    t.datetime "start_at"
    t.integer  "status",                default: 0,     null: false
    t.boolean  "multiple_choices",      default: false, null: false
    t.boolean  "ballots_changeable",    default: false, null: false
    t.integer  "maximum_choices"
    t.integer  "ballots_privacy",       default: 0,     null: false
    t.datetime "end_at"
    t.integer  "restriction",           default: 1,     null: false
    t.integer  "author_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "disabled",              default: false, null: false
    t.text     "description_markdown"
    t.string   "description_stripdown"
  end

  create_table "posts_teams", id: false, force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "team_id", null: false
  end

  add_index "posts_teams", ["post_id"], name: "index_posts_teams_on_post_id"
  add_index "posts_teams", ["team_id"], name: "index_posts_teams_on_team_id"

  create_table "registration_fields", force: :cascade do |t|
    t.string   "title",                     null: false
    t.string   "extra_info"
    t.integer  "input_type", default: 0,    null: false
    t.boolean  "optional",   default: true, null: false
    t.integer  "order",      default: 0,    null: false
    t.string   "map_to"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "scouting_entries", force: :cascade do |t|
    t.integer  "team_stat_id"
    t.integer  "member_id"
    t.text     "extra_note"
    t.integer  "drive_motors"
    t.string   "drive_motor_type"
    t.integer  "drive_wheels"
    t.string   "drive_wheel_type"
    t.string   "drive_configuration"
    t.string   "drive_clearance"
    t.string   "shooter_type"
    t.integer  "shooter_motors"
    t.integer  "shooter_rpm"
    t.string   "intake_type"
    t.integer  "intake_motors"
    t.string   "intake_motor_type"
    t.string   "intake_flip_capacity"
    t.string   "lift"
    t.integer  "lift_motors"
    t.string   "lift_elevation"
    t.string   "lift_works"
    t.string   "driver_consistency"
    t.string   "driver_intelligence"
    t.string   "preloads_capacity"
    t.string   "shooter_consistency"
    t.string   "shooter_range"
    t.string   "autonomous_strategy"
    t.integer  "autonomous_preload_points"
    t.integer  "autonomous_field_points"
    t.string   "autonomous_reliability"
    t.string   "stalling"
    t.string   "connection_issues"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "rating"
  end

  add_index "scouting_entries", ["member_id"], name: "index_scouting_entries_on_member_id"
  add_index "scouting_entries", ["team_stat_id"], name: "index_scouting_entries_on_team_stat_id"

  create_table "sponsors", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "image_link"
    t.string   "facebook_link"
    t.string   "twitter_link"
    t.string   "website_link"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "team_stats", force: :cascade do |t|
    t.string   "number"
    t.string   "team_name"
    t.integer  "robot_score"
    t.integer  "robot_rank"
    t.integer  "programming_score"
    t.integer  "programming_rank"
    t.string   "country"
    t.string   "city"
    t.string   "region"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "division_id"
    t.integer  "actual_order"
  end

  add_index "team_stats", ["division_id"], name: "index_team_stats_on_division_id"

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "image_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "videos", force: :cascade do |t|
    t.string   "title",       null: false
    t.string   "youtube_vid", null: false
    t.string   "author"
    t.date     "upload_date", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
