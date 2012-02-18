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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120218001154) do

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "cik"
    t.string   "city"
    t.string   "state"
    t.string   "incorporation_year"
    t.boolean  "featured"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "email_updates", :force => true do |t|
    t.string   "email"
    t.integer  "company_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "email_updates", ["company_id"], :name => "index_email_updates_on_company_id"

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "street_address_one"
    t.string   "street_address_two"
    t.string   "city"
    t.string   "zip_code"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "related_people", :force => true do |t|
    t.integer  "round_id"
    t.integer  "person_id"
    t.boolean  "executive_officer"
    t.boolean  "director"
    t.boolean  "promoter"
    t.string   "explanation"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "related_people", ["person_id"], :name => "index_related_people_on_person_id"
  add_index "related_people", ["round_id"], :name => "index_related_people_on_round_id"

  create_table "rounds", :force => true do |t|
    t.integer  "company_id"
    t.string   "accession",                                            :null => false
    t.string   "filing_url",                                           :null => false
    t.string   "use_of_funds",                  :default => "Unknown"
    t.string   "revenue_range",                 :default => "Unknown"
    t.string   "kind"
    t.date     "first_investment"
    t.date     "end_date"
    t.integer  "raised",           :limit => 8, :default => 0
    t.integer  "tried_to_raise",   :limit => 8, :default => 0
    t.integer  "investor_count",   :limit => 8, :default => 0
    t.integer  "minimum_invested", :limit => 8
    t.boolean  "merger"
    t.boolean  "acquired"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  add_index "rounds", ["company_id"], :name => "index_rounds_on_company_id"

  create_table "securities", :force => true do |t|
    t.integer  "round_id"
    t.boolean  "debt"
    t.boolean  "acquired"
    t.boolean  "equity"
    t.boolean  "option"
    t.boolean  "pooled_investment_fund"
    t.boolean  "tenant_in_common"
    t.boolean  "mineral_property"
    t.string   "other"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "securities", ["round_id"], :name => "index_securities_on_round_id"

end
