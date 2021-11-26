# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_11_25_145633) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bus_stops", force: :cascade do |t|
    t.bigint "route_id", null: false
    t.string "name"
    t.float "longitude"
    t.float "latitude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["route_id"], name: "index_bus_stops_on_route_id"
  end

  create_table "buses", force: :cascade do |t|
    t.bigint "line_id", null: false
    t.bigint "route_id", null: false
    t.boolean "agent"
    t.boolean "safetiness"
    t.integer "star_bus_id"
    t.string "star_destination"
    t.string "star_line_short_name"
    t.float "star_longitude"
    t.float "star_latitude"
    t.integer "star_line_id"
    t.integer "star_direction_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "crowd_level"
    t.boolean "noise_level"
    t.boolean "cleanliness_level"
    t.boolean "bad_smell_level"
    t.index ["line_id"], name: "index_buses_on_line_id"
    t.index ["route_id"], name: "index_buses_on_route_id"
  end

  create_table "itineraries", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "starting_point"
    t.string "end_point"
    t.time "departing_time"
    t.time "arrival_time"
    t.boolean "favorite"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_itineraries_on_user_id"
  end

  create_table "itinerary_buses", force: :cascade do |t|
    t.bigint "itinerary_id", null: false
    t.bigint "bus_id", null: false
    t.string "starting_point"
    t.string "end_point"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bus_id"], name: "index_itinerary_buses_on_bus_id"
    t.index ["itinerary_id"], name: "index_itinerary_buses_on_itinerary_id"
  end

  create_table "lines", force: :cascade do |t|
    t.integer "star_line_id"
    t.string "star_short_name"
    t.string "star_long_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "colour"
  end

  create_table "routes", force: :cascade do |t|
    t.text "route_json"
    t.string "star_route_id"
    t.integer "star_line_id"
    t.integer "star_direction_code"
    t.bigint "line_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "departure_stop"
    t.string "arrival_stop"
    t.index ["line_id"], name: "index_routes_on_line_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bus_stops", "routes"
  add_foreign_key "buses", "lines"
  add_foreign_key "buses", "routes"
  add_foreign_key "itineraries", "users"
  add_foreign_key "itinerary_buses", "buses"
  add_foreign_key "itinerary_buses", "itineraries"
  add_foreign_key "routes", "lines"
end
