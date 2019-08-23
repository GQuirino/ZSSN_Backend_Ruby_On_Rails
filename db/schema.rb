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

ActiveRecord::Schema.define(version: 2019_08_15_132457) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "inventories", force: :cascade do |t|
    t.bigint "survivor_id"
    t.string "resource_type", null: false
    t.integer "resource_amount", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_type"], name: "index_inventories_on_resource_type"
    t.index ["survivor_id"], name: "index_inventories_on_survivor_id"
    t.index ["survivor_id"], name: "newindex"
  end

  create_table "survivors", force: :cascade do |t|
    t.string "name", null: false
    t.string "gender", null: false
    t.integer "age", null: false
    t.integer "flag_as_infected", default: 0, null: false
    t.integer "points", null: false
    t.string "latitude", null: false
    t.string "longitude", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
