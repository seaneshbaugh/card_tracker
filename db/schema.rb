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

ActiveRecord::Schema.define(:version => 20140430001028) do

  create_table "card_block_types", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "card_block_types", ["created_at"], :name => "index_card_block_types_on_created_at"
  add_index "card_block_types", ["name"], :name => "index_card_block_types_on_name"
  add_index "card_block_types", ["updated_at"], :name => "index_card_block_types_on_updated_at"

  create_table "card_blocks", :force => true do |t|
    t.string   "name",               :default => "", :null => false
    t.integer  "card_block_type_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "card_blocks", ["card_block_type_id"], :name => "index_card_blocks_on_card_block_type_id"
  add_index "card_blocks", ["created_at"], :name => "index_card_blocks_on_created_at"
  add_index "card_blocks", ["name"], :name => "index_card_blocks_on_name", :unique => true
  add_index "card_blocks", ["updated_at"], :name => "index_card_blocks_on_updated_at"

  create_table "card_lists", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.string   "name",       :default => "",    :null => false
    t.string   "slug",       :default => "",    :null => false
    t.boolean  "have",       :default => true,  :null => false
    t.integer  "order",      :default => 0,     :null => false
    t.boolean  "default",    :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "card_lists", ["created_at"], :name => "index_card_lists_on_created_at"
  add_index "card_lists", ["default"], :name => "index_card_lists_on_default"
  add_index "card_lists", ["have"], :name => "index_card_lists_on_have"
  add_index "card_lists", ["name"], :name => "index_card_lists_on_name"
  add_index "card_lists", ["order"], :name => "index_card_lists_on_order"
  add_index "card_lists", ["slug"], :name => "index_card_lists_on_slug"
  add_index "card_lists", ["updated_at"], :name => "index_card_lists_on_updated_at"
  add_index "card_lists", ["user_id"], :name => "index_card_lists_on_user_id"

  create_table "card_parts", :force => true do |t|
    t.string   "multiverse_id",       :default => "", :null => false
    t.string   "name",                :default => "", :null => false
    t.integer  "card_id"
    t.string   "layout",              :default => "", :null => false
    t.string   "mana_cost",           :default => "", :null => false
    t.string   "converted_mana_cost", :default => "", :null => false
    t.string   "colors",              :default => "", :null => false
    t.string   "card_type",           :default => "", :null => false
    t.string   "card_supertypes",     :default => "", :null => false
    t.string   "card_types",          :default => "", :null => false
    t.string   "card_subtypes",       :default => "", :null => false
    t.text     "card_text",                           :null => false
    t.text     "flavor_text",                         :null => false
    t.string   "power",               :default => "", :null => false
    t.string   "toughness",           :default => "", :null => false
    t.string   "loyalty",             :default => "", :null => false
    t.string   "rarity",              :default => "", :null => false
    t.string   "card_number",         :default => "", :null => false
    t.string   "artist",              :default => "", :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "card_parts", ["artist"], :name => "index_card_parts_on_artist"
  add_index "card_parts", ["card_id"], :name => "index_card_parts_on_card_id"
  add_index "card_parts", ["card_number"], :name => "index_card_parts_on_card_number"
  add_index "card_parts", ["card_subtypes"], :name => "index_card_parts_on_card_subtypes"
  add_index "card_parts", ["card_supertypes"], :name => "index_card_parts_on_card_supertypes"
  add_index "card_parts", ["card_type"], :name => "index_card_parts_on_card_type"
  add_index "card_parts", ["card_types"], :name => "index_card_parts_on_card_types"
  add_index "card_parts", ["colors"], :name => "index_card_parts_on_colors"
  add_index "card_parts", ["converted_mana_cost"], :name => "index_card_parts_on_converted_mana_cost"
  add_index "card_parts", ["created_at"], :name => "index_card_parts_on_created_at"
  add_index "card_parts", ["layout"], :name => "index_card_parts_on_layout"
  add_index "card_parts", ["loyalty"], :name => "index_card_parts_on_loyalty"
  add_index "card_parts", ["mana_cost"], :name => "index_card_parts_on_mana_cost"
  add_index "card_parts", ["multiverse_id"], :name => "index_card_parts_on_multiverse_id"
  add_index "card_parts", ["name"], :name => "index_card_parts_on_name"
  add_index "card_parts", ["power"], :name => "index_card_parts_on_power"
  add_index "card_parts", ["rarity"], :name => "index_card_parts_on_rarity"
  add_index "card_parts", ["toughness"], :name => "index_card_parts_on_toughness"
  add_index "card_parts", ["updated_at"], :name => "index_card_parts_on_updated_at"

  create_table "card_sets", :force => true do |t|
    t.string   "name",              :default => "",   :null => false
    t.string   "slug",              :default => "",   :null => false
    t.integer  "card_block_id"
    t.string   "code",              :default => "",   :null => false
    t.date     "release_date"
    t.date     "prerelease_date"
    t.boolean  "show_card_numbers", :default => true, :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "card_sets", ["code"], :name => "index_card_sets_on_code"
  add_index "card_sets", ["created_at"], :name => "index_card_sets_on_created_at"
  add_index "card_sets", ["name"], :name => "index_card_sets_on_name"
  add_index "card_sets", ["prerelease_date"], :name => "index_card_sets_on_prerelease_date"
  add_index "card_sets", ["release_date"], :name => "index_card_sets_on_release_date"
  add_index "card_sets", ["show_card_numbers"], :name => "index_card_sets_on_show_card_numbers"
  add_index "card_sets", ["slug"], :name => "index_card_sets_on_slug"
  add_index "card_sets", ["updated_at"], :name => "index_card_sets_on_updated_at"

  create_table "cards", :force => true do |t|
    t.string   "multiverse_id",       :default => "", :null => false
    t.string   "name",                :default => "", :null => false
    t.integer  "card_set_id"
    t.string   "layout",              :default => "", :null => false
    t.string   "mana_cost",           :default => "", :null => false
    t.string   "converted_mana_cost", :default => "", :null => false
    t.string   "colors",              :default => "", :null => false
    t.string   "card_type",           :default => "", :null => false
    t.string   "card_supertypes",     :default => "", :null => false
    t.string   "card_types",          :default => "", :null => false
    t.string   "card_subtypes",       :default => "", :null => false
    t.text     "card_text",                           :null => false
    t.text     "flavor_text",                         :null => false
    t.string   "power",               :default => "", :null => false
    t.string   "toughness",           :default => "", :null => false
    t.string   "loyalty",             :default => "", :null => false
    t.string   "rarity",              :default => "", :null => false
    t.string   "card_number",         :default => "", :null => false
    t.string   "artist",              :default => "", :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "cards", ["artist"], :name => "index_cards_on_artist"
  add_index "cards", ["card_number"], :name => "index_cards_on_card_number"
  add_index "cards", ["card_set_id"], :name => "index_cards_on_card_set_id"
  add_index "cards", ["card_subtypes"], :name => "index_cards_on_card_subtypes"
  add_index "cards", ["card_supertypes"], :name => "index_cards_on_card_supertypes"
  add_index "cards", ["card_type"], :name => "index_cards_on_card_type"
  add_index "cards", ["card_types"], :name => "index_cards_on_card_types"
  add_index "cards", ["colors"], :name => "index_cards_on_colors"
  add_index "cards", ["converted_mana_cost"], :name => "index_cards_on_converted_mana_cost"
  add_index "cards", ["created_at"], :name => "index_cards_on_created_at"
  add_index "cards", ["layout"], :name => "index_cards_on_layout"
  add_index "cards", ["loyalty"], :name => "index_cards_on_loyalty"
  add_index "cards", ["mana_cost"], :name => "index_cards_on_mana_cost"
  add_index "cards", ["multiverse_id"], :name => "index_cards_on_multiverse_id"
  add_index "cards", ["name"], :name => "index_cards_on_name"
  add_index "cards", ["power"], :name => "index_cards_on_power"
  add_index "cards", ["rarity"], :name => "index_cards_on_rarity"
  add_index "cards", ["toughness"], :name => "index_cards_on_toughness"
  add_index "cards", ["updated_at"], :name => "index_cards_on_updated_at"

  create_table "collections", :force => true do |t|
    t.integer  "card_id",                     :null => false
    t.integer  "user_id",                     :null => false
    t.integer  "card_list_id"
    t.integer  "quantity",     :default => 0, :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "collections", ["card_id"], :name => "index_collections_on_card_id"
  add_index "collections", ["card_list_id"], :name => "index_collections_on_card_list_id"
  add_index "collections", ["created_at"], :name => "index_collections_on_created_at"
  add_index "collections", ["quantity"], :name => "index_collections_on_quantity"
  add_index "collections", ["updated_at"], :name => "index_collections_on_updated_at"
  add_index "collections", ["user_id"], :name => "index_collections_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "users", :force => true do |t|
    t.string   "username",               :default => "", :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "role",                   :default => "", :null => false
    t.string   "first_name",             :default => "", :null => false
    t.string   "last_name",              :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.boolean  "receive_newsletters"
    t.boolean  "receive_sign_up_alerts"
    t.boolean  "receive_contact_alerts"
    t.text     "api_privacy_settings"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token"
  add_index "users", ["confirmation_sent_at"], :name => "index_users_on_confirmation_sent_at"
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token"
  add_index "users", ["confirmed_at"], :name => "index_users_on_confirmed_at"
  add_index "users", ["created_at"], :name => "index_users_on_created_at"
  add_index "users", ["current_sign_in_at"], :name => "index_users_on_current_sign_in_at"
  add_index "users", ["current_sign_in_ip"], :name => "index_users_on_current_sign_in_ip"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["encrypted_password"], :name => "index_users_on_encrypted_password"
  add_index "users", ["failed_attempts"], :name => "index_users_on_failed_attempts"
  add_index "users", ["first_name"], :name => "index_users_on_first_name"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"
  add_index "users", ["last_sign_in_at"], :name => "index_users_on_last_sign_in_at"
  add_index "users", ["last_sign_in_ip"], :name => "index_users_on_last_sign_in_ip"
  add_index "users", ["locked_at"], :name => "index_users_on_locked_at"
  add_index "users", ["receive_contact_alerts"], :name => "index_users_on_receive_contact_alerts"
  add_index "users", ["receive_newsletters"], :name => "index_users_on_receive_newsletters"
  add_index "users", ["receive_sign_up_alerts"], :name => "index_users_on_receive_sign_up_alerts"
  add_index "users", ["remember_created_at"], :name => "index_users_on_remember_created_at"
  add_index "users", ["reset_password_sent_at"], :name => "index_users_on_reset_password_sent_at"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"
  add_index "users", ["role"], :name => "index_users_on_role"
  add_index "users", ["sign_in_count"], :name => "index_users_on_sign_in_count"
  add_index "users", ["unconfirmed_email"], :name => "index_users_on_unconfirmed_email"
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token"
  add_index "users", ["updated_at"], :name => "index_users_on_updated_at"
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
