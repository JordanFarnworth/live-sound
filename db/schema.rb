ActiveRecord::Schema.define(version: 20160810193105) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bands", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.text     "social_media"
    t.datetime "deleted_at"
    t.string   "address"
    t.float    "longitude"
    t.float    "latitude"
    t.string   "braintree_customer_id"
    t.datetime "subscription_expires_at"
    t.string   "youtube_link"
    t.string   "email"
    t.string   "genre"
    t.string   "phone_number"
    t.text     "settings"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "workflow_state"
  end

  create_table "enterprises", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.text     "social_media"
    t.datetime "deleted_at"
    t.string   "address"
    t.float    "longitude"
    t.float    "latitude"
    t.string   "braintree_customer_id"
    t.datetime "subscription_expires_at"
    t.string   "youtube_link"
    t.string   "email"
    t.string   "phone_number"
    t.string   "workflow_state"
    t.text     "settings"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "entity_users", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "workflow_state"
    t.string   "userable_type"
    t.integer  "userable_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["user_id"], name: "index_entity_users_on_user_id", using: :btree
    t.index ["userable_type", "userable_id"], name: "index_entity_users_on_userable_type_and_userable_id", using: :btree
  end

  create_table "event_applications", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "workflow_state"
    t.string   "applicable_type"
    t.integer  "applicable_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "application_type"
    t.index ["applicable_type", "applicable_id"], name: "index_event_applications_on_applicable_type_and_applicable_id", using: :btree
    t.index ["event_id"], name: "index_event_applications_on_event_id", using: :btree
  end

  create_table "event_invitations", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "workflow_state"
    t.string   "invitable_type"
    t.integer  "invitable_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.datetime "deleted_at"
    t.string   "role"
    t.index ["deleted_at"], name: "index_event_invitations_on_deleted_at", using: :btree
    t.index ["event_id"], name: "index_event_invitations_on_event_id", using: :btree
    t.index ["invitable_id", "invitable_type", "role"], name: "index_event_invitations_on_invitable_id_type_role", unique: true, using: :btree
    t.index ["invitable_type", "invitable_id"], name: "index_event_invitations_on_invitable_type_and_invitable_id", using: :btree
    t.index ["role"], name: "index_event_invitations_on_role", using: :btree
  end

  create_table "event_members", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "workflow_state"
    t.string   "memberable_type"
    t.integer  "memberable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.datetime "deleted_at"
    t.string   "role"
    t.index ["deleted_at"], name: "index_event_members_on_deleted_at", using: :btree
    t.index ["event_id"], name: "index_event_members_on_event_id", using: :btree
    t.index ["memberable_id", "memberable_type", "role"], name: "index_event_members_on_memberable_id_type_role", unique: true, using: :btree
    t.index ["memberable_type", "memberable_id"], name: "index_event_members_on_memberable_type_and_memberable_id", using: :btree
    t.index ["role"], name: "index_event_members_on_role", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "recurrence_pattern"
    t.datetime "recurrence_ends_at"
    t.string   "status"
    t.string   "workflow_state"
    t.integer  "price"
    t.string   "title"
    t.text     "description"
    t.string   "address"
    t.float    "longitude"
    t.float    "latitude"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_events_on_deleted_at", using: :btree
  end

  create_table "favorites", force: :cascade do |t|
    t.string   "favoriterable_type"
    t.integer  "favoriterable_id"
    t.string   "favoritable_type"
    t.integer  "favoritable_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["favoritable_type", "favoritable_id"], name: "index_favorites_on_favoritable_type_and_favoritable_id", using: :btree
    t.index ["favoriterable_type", "favoriterable_id"], name: "index_favorites_on_favoriterable_type_and_favoriterable_id", using: :btree
  end

  create_table "jwt_sessions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "jwt_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jwt_id"], name: "index_jwt_sessions_on_jwt_id", using: :btree
    t.index ["user_id"], name: "index_jwt_sessions_on_user_id", using: :btree
  end

  create_table "message_participants", force: :cascade do |t|
    t.integer  "message_id"
    t.integer  "entity_id"
    t.string   "entity_type"
    t.string   "workflow_state"
    t.datetime "deleted_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["deleted_at"], name: "index_message_participants_on_deleted_at", using: :btree
    t.index ["entity_id", "entity_type"], name: "index_message_participants_on_entity_id_and_entity_type", using: :btree
    t.index ["message_id"], name: "index_message_participants_on_message_id", using: :btree
  end

  create_table "message_thread_participants", force: :cascade do |t|
    t.integer  "message_thread_id"
    t.integer  "entity_id"
    t.string   "entity_type"
    t.string   "workflow_state"
    t.datetime "deleted_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["deleted_at"], name: "index_message_thread_participants_on_deleted_at", using: :btree
    t.index ["entity_id", "entity_type"], name: "index_message_thread_participants_on_entity_id_and_entity_type", using: :btree
    t.index ["message_thread_id"], name: "index_message_thread_participants_on_message_thread_id", using: :btree
  end

  create_table "message_threads", force: :cascade do |t|
    t.string   "subject"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_message_threads_on_deleted_at", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "message_thread_id"
    t.text     "body"
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "deleted_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["author_id", "author_type"], name: "index_messages_on_author_id_and_author_type", using: :btree
    t.index ["deleted_at"], name: "index_messages_on_deleted_at", using: :btree
    t.index ["message_thread_id"], name: "index_messages_on_message_thread_id", using: :btree
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "notifiable_type"
    t.integer  "notifiable_id"
    t.string   "contextable_type"
    t.integer  "contextable_id"
    t.text     "description"
    t.string   "workflow_state"
    t.datetime "deleted_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["contextable_type", "contextable_id"], name: "index_notifications_on_contextable_type_and_contextable_id", using: :btree
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id", using: :btree
  end

  create_table "private_parties", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.text     "social_media"
    t.datetime "deleted_at"
    t.string   "address"
    t.float    "longitude"
    t.float    "latitude"
    t.string   "braintree_customer_id"
    t.datetime "subscription_expires_at"
    t.string   "youtube_link"
    t.string   "email"
    t.string   "phone_number"
    t.text     "settings"
    t.string   "workflow_state"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.string   "reviewerable_type"
    t.integer  "reviewerable_id"
    t.string   "reviewable_type"
    t.integer  "reviewable_id"
    t.text     "text"
    t.integer  "rating"
    t.string   "workflow_state"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["reviewable_type", "reviewable_id"], name: "index_reviews_on_reviewable_type_and_reviewable_id", using: :btree
    t.index ["reviewerable_type", "reviewerable_id"], name: "index_reviews_on_reviewerable_type_and_reviewerable_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "display_name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "workflow_state"
    t.string   "registration_token"
    t.text     "settings"
    t.boolean  "single_user"
    t.datetime "deleted_at"
    t.string   "address"
    t.string   "uid"
    t.string   "provider"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "facebook_image_url"
    t.float    "longitude"
    t.float    "latitude"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_foreign_key "entity_users", "users"
  add_foreign_key "event_applications", "events"
  add_foreign_key "event_invitations", "events"
  add_foreign_key "event_members", "events"
  add_foreign_key "jwt_sessions", "users"
  add_foreign_key "message_participants", "messages"
  add_foreign_key "message_thread_participants", "message_threads"
  add_foreign_key "messages", "message_threads"
end
