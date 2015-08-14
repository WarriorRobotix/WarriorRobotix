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

ActiveRecord::Schema.define(version: 20150813170003) do

  create_table "attendances", force: :cascade do |t|
    t.integer  "member_id",              null: false
    t.integer  "event_id"
    t.integer  "status",     default: 0, null: false
    t.integer  "reply",      default: 0, null: false
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.time     "duration"
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

  create_table "members", force: :cascade do |t|
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "first_name",                            null: false
    t.string   "last_name",                             null: false
    t.string   "title"
    t.string   "team"
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

  create_table "posts", force: :cascade do |t|
    t.string   "type"
    t.string   "title"
    t.text     "description"
    t.datetime "start_at"
    t.integer  "status",             default: 0,     null: false
    t.boolean  "multiple_choices",   default: false, null: false
    t.boolean  "ballots_changeable", default: false, null: false
    t.integer  "maximum_choices"
    t.integer  "ballots_privacy",    default: 0,     null: false
    t.datetime "end_at"
    t.integer  "restriction",        default: 0,     null: false
    t.integer  "author_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

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

end
