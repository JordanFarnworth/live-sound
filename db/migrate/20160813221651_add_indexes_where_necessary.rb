class AddIndexesWhereNecessary < ActiveRecord::Migration[5.0]
  def change
    add_index :bands, :braintree_customer_id
    add_index :bands, :deleted_at
    add_index :bands, :name

    add_index :enterprises, :braintree_customer_id
    add_index :enterprises, :deleted_at
    add_index :enterprises, :name

    add_index :private_parties, :braintree_customer_id
    add_index :private_parties, :deleted_at
    add_index :private_parties, :name

    add_index :users, :username
    add_index :users, :email
    add_index :users, :uid
    add_index :users, :deleted_at

    remove_index :event_memberships, name: 'index_event_memberships_on_memberable_type_and_memberable_id'
    remove_index :event_memberships, name: 'index_event_memberships_on_role'

    add_index :notifications, :deleted_at
    remove_index :notifications, name: 'index_notifications_on_contextable_type_and_contextable_id'
    add_index :notifications, [:contextable_id, :contextable_type]
    remove_index :notifications, name: 'index_notifications_on_notifiable_type_and_notifiable_id'
    add_index :notifications, [:notifiable_id, :notifiable_type]

    remove_index :reviews, name: 'index_reviews_on_reviewable_type_and_reviewable_id'
    add_index :reviews, [:reviewable_id, :reviewable_type]
    remove_index :reviews, name: 'index_reviews_on_reviewerable_type_and_reviewerable_id'
    add_index :reviews, [:reviewerable_id, :reviewerable_type]
  end
end
