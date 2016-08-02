class DefaultMigration < ActiveRecord::Migration[5.0]
  def change

    create_table :enterprises do |t|
      t.string :name
      t.text :description
      t.text :social_media
      t.datetime :deleted_at
      t.string :address
      t.float :longitude
      t.float :latitude
      t.string :braintree_customer_id
      t.datetime :subscription_expires_at
      t.string :youtube_link
      t.string :email
      t.string :phone_number
      t.string :state
      t.text :settings

      t.timestamps null: false
    end

    create_table :private_parties do |t|
      t.string :name
      t.text :description
      t.text :social_media
      t.datetime :deleted_at
      t.string :address
      t.float :longitude
      t.float :latitude
      t.string :braintree_customer_id
      t.datetime :subscription_expires_at
      t.string :youtube_link
      t.string :email
      t.string :phone_number
      t.text :settings
      t.string :state

      t.timestamps null: false

      t.timestamps null: false
    end

    create_table :bands do |t|
      t.string :name
      t.text :description
      t.text :social_media
      t.datetime :deleted_at
      t.string :address
      t.float :longitude
      t.float :latitude
      t.string :braintree_customer_id
      t.datetime :subscription_expires_at
      t.string :youtube_link
      t.string :email
      t.string :genre
      t.string :phone_number
      t.string :state
      t.text :settings

      t.timestamps null: false
    end

    create_table :events do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :recurrence_pattern
      t.datetime :recurrence_ends_at
      t.string :status
      t.string :state
      t.integer :price
      t.string :title
      t.text :description
      t.string :status
      t.string :address
      t.float :longitude
      t.float :latitude

      t.timestamps null: false
    end

    create_table :users do |t|
      t.string :username
      t.string :display_name
      t.string :email
      t.string :password_digest
      t.string :state
      t.string :registration_token
      t.text :settings
      t.boolean :single_user
      t.datetime :deleted_at
      t.string :address
      t.string :uid
      t.string :provider
      t.string :oauth_token
      t.datetime :oauth_expires_at
      t.string :facebook_image_url
      t.float :longitude
      t.float :latitude

      t.timestamps null: false
    end

    create_table :event_members do |t|
      t.references :event, index: true, foreign_key: true
      t.string :member_type
      t.string :status
      t.references :memberable, polymorphic: true, index: true

      t.timestamps null: false
    end

    create_table :entity_users do |t|
      t.references :user, index: true, foreign_key: true
      t.string :status
      t.string :state
      t.references :userable, polymorphic: true, index: true

      t.timestamps null: false
    end

    create_table :event_invitations do |t|
      t.references :event, index: true, foreign_key: true
      t.string :status
      t.string :state
      t.references :invitable, polymorphic: true, index: true

      t.timestamps null: false
    end

    create_table :reviews do |t|
      t.references :reviewerable, polymorphic: true, index: true
      t.references :reviewable, polymorphic: true, index: true
      t.text :text
      t.integer :rating

      t.timestamps null: false
    end

    create_table :favorites do |t|
      t.references :favoriterable, polymorphic: true, index: true
      t.references :favoritable, polymorphic: true, index: true

      t.timestamps null: false
    end

    create_table :notifications do |t|
      t.references :notifiable, polymorphic: true, index: true
      t.references :contextable, polymorphic: true, index: true
      t.text :description
      t.string :state
      t.datetime :deleted_at

      t.timestamps null: false
    end

    create_table :api_keys do |t|
      t.references :user, index: true, foreign_key: true
      t.string :key
      t.string :key_hint
      t.datetime :expires_at

      t.timestamps null: false
    end

    create_table :event_applications do |t|
      t.references :event, index: true, foreign_key: true
      t.string :status
      t.string :state
      t.references :applicable, polymorphic: true, index: true

      t.timestamps null: false
    end

  end
end
