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

ActiveRecord::Schema.define(version: 20150923180342) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.integer  "rating_id"
    t.integer  "option_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "answers", ["option_id"], name: "index_answers_on_option_id", using: :btree
  add_index "answers", ["rating_id"], name: "index_answers_on_rating_id", using: :btree

  create_table "claims", force: :cascade do |t|
    t.integer  "restaurant_id"
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "tel"
    t.string   "address"
    t.string   "locality"
    t.string   "region"
    t.string   "zipcode"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "active",        default: true
  end

  create_table "dg_imports", force: :cascade do |t|
    t.string   "file_name"
    t.string   "import_type"
    t.integer  "total",       default: 0
    t.integer  "insert_cnt",  default: 0
    t.integer  "update_cnt",  default: 0
    t.integer  "error_cnt",   default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "dg_ratings", force: :cascade do |t|
    t.decimal  "bill"
    t.date     "dateOfDine"
    t.string   "comments"
    t.string   "response"
    t.inet     "ip_addr"
    t.string   "source"
    t.datetime "timestamp"
    t.decimal  "cleanliness_rating"
    t.decimal  "satisfaction_rating"
    t.decimal  "recommendation_rating"
    t.string   "restaurant_name"
    t.string   "email"
    t.string   "store_number"
    t.string   "telephone"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.decimal  "lat",                   precision: 12, scale: 6
    t.decimal  "lon",                   precision: 12, scale: 6
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "license_id"
    t.integer  "dg_import_id"
    t.integer  "restaurant_id"
  end

  create_table "food_reports", force: :cascade do |t|
    t.integer  "restaurant_id"
    t.text     "comment"
    t.boolean  "fever",               default: false
    t.boolean  "nausea",              default: false
    t.boolean  "vomiting",            default: false
    t.boolean  "diarrhea",            default: false
    t.boolean  "abdominal_pain",      default: false
    t.boolean  "headache",            default: false
    t.boolean  "chest_pain",          default: false
    t.boolean  "numbness_tingling",   default: false
    t.boolean  "dizziness",           default: false
    t.boolean  "rash",                default: false
    t.date     "date_of_exposure"
    t.string   "suspected_food_time"
    t.boolean  "healthcare_provider", default: false
    t.string   "provider_email"
    t.string   "patient_name"
    t.string   "patient_telephone"
    t.boolean  "patient_antibiotic",  default: false
    t.string   "facility_name"
    t.string   "facility_phone"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "send_to_restaurant",  default: false
  end

  add_index "food_reports", ["restaurant_id"], name: "index_food_reports_on_restaurant_id", using: :btree

  create_table "options", force: :cascade do |t|
    t.integer  "question_id"
    t.string   "title"
    t.integer  "deduction"
    t.integer  "position"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "options", ["position"], name: "index_options_on_position", using: :btree
  add_index "options", ["question_id"], name: "index_options_on_question_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.text     "question"
    t.boolean  "extended",   default: false
    t.string   "category"
    t.integer  "position"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "questions", ["category"], name: "index_questions_on_category", using: :btree
  add_index "questions", ["position"], name: "index_questions_on_position", using: :btree

  create_table "ratings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.decimal  "satisfaction"
    t.decimal  "recommendation"
    t.text     "comment"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "restaurants", force: :cascade do |t|
    t.string   "factual_id"
    t.string   "category_ids"
    t.string   "cuisine"
    t.string   "name"
    t.string   "country"
    t.string   "region"
    t.string   "locality"
    t.string   "address"
    t.string   "address_extended"
    t.string   "website"
    t.string   "email"
    t.string   "tel"
    t.string   "postcode"
    t.string   "hours_display"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.decimal  "satisfaction",         default: 0.0,  null: false
    t.decimal  "recommendation",       default: 0.0,  null: false
    t.decimal  "grades",               default: 0.0,  null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "active",               default: true
    t.decimal  "total_satisfaction",   default: 0.0
    t.decimal  "total_recommendation", default: 0.0
    t.integer  "rating_count",         default: 0
  end

  add_index "restaurants", ["factual_id"], name: "index_restaurants_on_factual_id", unique: true, using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_restaurants", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "user_restaurants", ["restaurant_id"], name: "index_user_restaurants_on_restaurant_id", using: :btree
  add_index "user_restaurants", ["user_id"], name: "index_user_restaurants_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.string   "zipcode"
    t.integer  "role_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

  add_foreign_key "answers", "options"
  add_foreign_key "answers", "ratings"
  add_foreign_key "food_reports", "restaurants"
  add_foreign_key "options", "questions"
  add_foreign_key "user_restaurants", "restaurants"
  add_foreign_key "user_restaurants", "users"
  add_foreign_key "users", "roles"
end
