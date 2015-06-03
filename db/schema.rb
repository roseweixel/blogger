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

ActiveRecord::Schema.define(version: 20150603194422) do

  create_table "blog_assignments", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "due_date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "schedule_id"
  end

  create_table "blogs", force: :cascade do |t|
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.string   "title"
    t.string   "feed_url"
  end

  create_table "cohorts", force: :cascade do |t|
    t.string   "name"
    t.string   "roster_csv_file_name"
    t.string   "roster_csv_content_type"
    t.integer  "roster_csv_file_size"
    t.datetime "roster_csv_updated_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "holidays", force: :cascade do |t|
    t.date "date"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "cohort_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "blog_id"
    t.string   "title"
    t.datetime "published_date"
    t.string   "url"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.text     "content"
    t.text     "summary"
  end

  create_table "schedules", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "frequency"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "name"
    t.integer  "cohort_id"
    t.boolean  "rotation_locked", default: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "github_username"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "provider"
    t.string   "uid"
    t.string   "image"
    t.string   "access_token"
    t.boolean  "admin",           default: false
  end

end
