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

ActiveRecord::Schema.define(version: 2019_05_01_201847) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "card_blocks", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_card_blocks_on_created_at"
    t.index ["name"], name: "index_card_blocks_on_name", unique: true
    t.index ["updated_at"], name: "index_card_blocks_on_updated_at"
  end

  create_table "card_colorings", force: :cascade do |t|
    t.integer "card_id", null: false
    t.string "color_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id", "color_code"], name: "index_card_colorings_on_card_id_and_color_code"
    t.index ["color_code", "card_id"], name: "index_card_colorings_on_color_code_and_card_id"
  end

  create_table "card_lists", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", default: "", null: false
    t.string "slug", default: "", null: false
    t.boolean "have", default: true, null: false
    t.integer "order", default: 0, null: false
    t.boolean "default", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_card_lists_on_created_at"
    t.index ["default"], name: "index_card_lists_on_default"
    t.index ["have"], name: "index_card_lists_on_have"
    t.index ["name"], name: "index_card_lists_on_name"
    t.index ["order"], name: "index_card_lists_on_order"
    t.index ["slug"], name: "index_card_lists_on_slug"
    t.index ["updated_at"], name: "index_card_lists_on_updated_at"
    t.index ["user_id"], name: "index_card_lists_on_user_id"
  end

  create_table "card_parts", force: :cascade do |t|
    t.string "multiverse_id", default: "", null: false
    t.string "name", default: "", null: false
    t.integer "card_id"
    t.string "layout", default: "", null: false
    t.string "mana_cost", default: "", null: false
    t.string "converted_mana_cost", default: "", null: false
    t.string "colors", default: "", null: false
    t.string "card_type", default: "", null: false
    t.string "card_supertypes", default: "", null: false
    t.string "card_types", default: "", null: false
    t.string "card_subtypes", default: "", null: false
    t.text "card_text", null: false
    t.text "flavor_text", null: false
    t.string "power", default: "", null: false
    t.string "toughness", default: "", null: false
    t.string "loyalty", default: "", null: false
    t.string "rarity", default: "", null: false
    t.string "card_number", default: "", null: false
    t.string "artist", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist"], name: "index_card_parts_on_artist"
    t.index ["card_id"], name: "index_card_parts_on_card_id"
    t.index ["card_number"], name: "index_card_parts_on_card_number"
    t.index ["card_subtypes"], name: "index_card_parts_on_card_subtypes"
    t.index ["card_supertypes"], name: "index_card_parts_on_card_supertypes"
    t.index ["card_type"], name: "index_card_parts_on_card_type"
    t.index ["card_types"], name: "index_card_parts_on_card_types"
    t.index ["colors"], name: "index_card_parts_on_colors"
    t.index ["converted_mana_cost"], name: "index_card_parts_on_converted_mana_cost"
    t.index ["created_at"], name: "index_card_parts_on_created_at"
    t.index ["layout"], name: "index_card_parts_on_layout"
    t.index ["loyalty"], name: "index_card_parts_on_loyalty"
    t.index ["mana_cost"], name: "index_card_parts_on_mana_cost"
    t.index ["multiverse_id"], name: "index_card_parts_on_multiverse_id"
    t.index ["name"], name: "index_card_parts_on_name"
    t.index ["power"], name: "index_card_parts_on_power"
    t.index ["rarity"], name: "index_card_parts_on_rarity"
    t.index ["toughness"], name: "index_card_parts_on_toughness"
    t.index ["updated_at"], name: "index_card_parts_on_updated_at"
  end

  create_table "card_set_types", primary_key: "card_set_type_code", id: :string, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "card_sets", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "slug", default: "", null: false
    t.integer "card_block_id"
    t.string "code", default: "", null: false
    t.date "release_date"
    t.date "prerelease_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "card_set_type_code", null: false
    t.index ["card_set_type_code"], name: "index_card_sets_on_card_set_type_code"
    t.index ["code"], name: "index_card_sets_on_code"
    t.index ["created_at"], name: "index_card_sets_on_created_at"
    t.index ["name"], name: "index_card_sets_on_name"
    t.index ["prerelease_date"], name: "index_card_sets_on_prerelease_date"
    t.index ["release_date"], name: "index_card_sets_on_release_date"
    t.index ["slug"], name: "index_card_sets_on_slug"
    t.index ["updated_at"], name: "index_card_sets_on_updated_at"
  end

  create_table "card_sub_types", primary_key: "card_sub_type_code", id: :string, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "card_sub_typings", force: :cascade do |t|
    t.integer "card_id", null: false
    t.string "card_sub_type_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id", "card_sub_type_code"], name: "index_card_sub_typings_on_card_id_and_card_sub_type_code"
    t.index ["card_sub_type_code", "card_id"], name: "index_card_sub_typings_on_card_sub_type_code_and_card_id"
  end

  create_table "card_super_types", primary_key: "card_super_type_code", id: :string, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "card_super_typings", force: :cascade do |t|
    t.integer "card_id", null: false
    t.string "card_super_type_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id", "card_super_type_code"], name: "index_card_super_typings_on_card_id_and_card_super_type_code"
    t.index ["card_super_type_code", "card_id"], name: "index_card_super_typings_on_card_super_type_code_and_card_id"
  end

  create_table "card_types", primary_key: "card_type_code", id: :string, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "card_typings", force: :cascade do |t|
    t.integer "card_id", null: false
    t.string "card_type_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id", "card_type_code"], name: "index_card_typings_on_card_id_and_card_type_code"
    t.index ["card_type_code", "card_id"], name: "index_card_typings_on_card_type_code_and_card_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "multiverse_id", default: "", null: false
    t.string "name", default: "", null: false
    t.integer "card_set_id"
    t.string "layout", default: "", null: false
    t.string "mana_cost", default: "", null: false
    t.string "converted_mana_cost", default: "", null: false
    t.string "colors", default: "", null: false
    t.string "type_text", default: "", null: false
    t.text "card_text", null: false
    t.text "flavor_text", null: false
    t.string "power", default: "", null: false
    t.string "toughness", default: "", null: false
    t.string "loyalty", default: "", null: false
    t.string "rarity_code", default: "", null: false
    t.string "card_number", default: "", null: false
    t.string "artist", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist"], name: "index_cards_on_artist"
    t.index ["card_number"], name: "index_cards_on_card_number"
    t.index ["card_set_id"], name: "index_cards_on_card_set_id"
    t.index ["colors"], name: "index_cards_on_colors"
    t.index ["converted_mana_cost"], name: "index_cards_on_converted_mana_cost"
    t.index ["layout"], name: "index_cards_on_layout"
    t.index ["loyalty"], name: "index_cards_on_loyalty"
    t.index ["mana_cost"], name: "index_cards_on_mana_cost"
    t.index ["multiverse_id"], name: "index_cards_on_multiverse_id"
    t.index ["name"], name: "index_cards_on_name"
    t.index ["power"], name: "index_cards_on_power"
    t.index ["rarity_code"], name: "index_cards_on_rarity_code"
    t.index ["toughness"], name: "index_cards_on_toughness"
  end

  create_table "collections", force: :cascade do |t|
    t.integer "card_id", null: false
    t.integer "user_id", null: false
    t.integer "card_list_id"
    t.integer "quantity", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_collections_on_card_id"
    t.index ["card_list_id"], name: "index_collections_on_card_list_id"
    t.index ["created_at"], name: "index_collections_on_created_at"
    t.index ["quantity"], name: "index_collections_on_quantity"
    t.index ["updated_at"], name: "index_collections_on_updated_at"
    t.index ["user_id"], name: "index_collections_on_user_id"
  end

  create_table "colors", primary_key: "color_code", id: :string, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "rarities", primary_key: "rarity_code", id: :string, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "role", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0
    t.string "unlock_token"
    t.datetime "locked_at"
    t.boolean "receive_newsletters"
    t.boolean "receive_sign_up_alerts"
    t.boolean "receive_contact_alerts"
    t.text "api_privacy_settings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["receive_contact_alerts"], name: "index_users_on_receive_contact_alerts"
    t.index ["receive_newsletters"], name: "index_users_on_receive_newsletters"
    t.index ["receive_sign_up_alerts"], name: "index_users_on_receive_sign_up_alerts"
    t.index ["remember_created_at"], name: "index_users_on_remember_created_at"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "card_colorings", "cards"
  add_foreign_key "card_colorings", "colors", column: "color_code", primary_key: "color_code"
  add_foreign_key "card_sets", "card_set_types", column: "card_set_type_code", primary_key: "card_set_type_code"
  add_foreign_key "card_sub_typings", "card_sub_types", column: "card_sub_type_code", primary_key: "card_sub_type_code"
  add_foreign_key "card_sub_typings", "cards"
  add_foreign_key "card_super_typings", "card_super_types", column: "card_super_type_code", primary_key: "card_super_type_code"
  add_foreign_key "card_super_typings", "cards"
  add_foreign_key "card_typings", "card_types", column: "card_type_code", primary_key: "card_type_code"
  add_foreign_key "card_typings", "cards"
  add_foreign_key "cards", "rarities", column: "rarity_code", primary_key: "rarity_code"
end
