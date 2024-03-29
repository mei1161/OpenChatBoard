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

ActiveRecord::Schema.define(version: 2019_12_04_052226) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "recruitment_comments", force: :cascade do |t|
    t.string "text"
    t.string "password_digest"
    t.bigint "recruitment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ancestry"
    t.index ["ancestry"], name: "index_recruitment_comments_on_ancestry"
    t.index ["recruitment_id"], name: "index_recruitment_comments_on_recruitment_id"
  end

  create_table "recruitments", force: :cascade do |t|
    t.string "room_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "room_url"
    t.string "password_digest"
  end

  add_foreign_key "recruitment_comments", "recruitments"
end
