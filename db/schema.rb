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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100829083627) do

  create_table "addresses", :force => true do |t|
    t.string "street"
    t.string "city"
    t.string "zip"
    t.string "country"
  end

  create_table "messages", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.integer  "from_id",    :limit => 0
    t.integer  "to_id",      :limit => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profile_attributes", :force => true do |t|
    t.string  "attr_type"
    t.string  "value"
    t.integer "profile_id", :limit => 0
  end

  create_table "profiles", :force => true do |t|
    t.string   "profession"
    t.string   "company"
    t.string   "image"
    t.text     "about"
    t.integer  "user_id",             :limit => 0
    t.integer  "private_address_id",  :limit => 0
    t.integer  "business_address_id", :limit => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
  end

  create_table "relations", :force => true do |t|
    t.integer  "source_id",      :limit => 0
    t.integer  "destination_id", :limit => 0
    t.string   "comment"
    t.boolean  "accepted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", :force => true do |t|
    t.text     "message"
    t.integer  "profile_id", :limit => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
