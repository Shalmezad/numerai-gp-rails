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

ActiveRecord::Schema.define(version: 20170516192155) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "demes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "generation", default: 1
    t.integer "max_size", default: 20
  end

  create_table "generation_stats", force: :cascade do |t|
    t.bigint "deme_id"
    t.integer "generation"
    t.string "best_gene"
    t.decimal "min"
    t.decimal "max"
    t.decimal "avg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deme_id"], name: "index_generation_stats_on_deme_id"
  end

  create_table "programs", force: :cascade do |t|
    t.bigint "deme_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "gene"
    t.decimal "log_loss"
    t.integer "generation"
    t.index ["deme_id"], name: "index_programs_on_deme_id"
  end

  create_table "training_data", force: :cascade do |t|
    t.integer "n_id"
    t.string "era"
    t.string "data_type"
    t.decimal "feature1"
    t.decimal "feature2"
    t.decimal "feature3"
    t.decimal "feature4"
    t.decimal "feature5"
    t.decimal "feature6"
    t.decimal "feature7"
    t.decimal "feature8"
    t.decimal "feature9"
    t.decimal "feature10"
    t.decimal "feature11"
    t.decimal "feature12"
    t.decimal "feature13"
    t.decimal "feature14"
    t.decimal "feature15"
    t.decimal "feature16"
    t.decimal "feature17"
    t.decimal "feature18"
    t.decimal "feature19"
    t.decimal "feature20"
    t.decimal "feature21"
    t.integer "target"
  end

end
