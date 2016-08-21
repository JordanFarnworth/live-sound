module Entityable
  extend ActiveSupport::Concern

  ENTITYABLE_CLASSES = %w(Band Enterprise PrivateParty User)

  included do

    # has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
    # validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
    has_many :users, through: :entity_users, as: :userable
    has_many :entity_users, as: :userable
    has_many :events, as: :memberable, through: :event_memberships
    has_many :event_memberships, as: :memberable
    has_many :events_applied_to, through: :event_applications, as: :applicable, source: "event"
    has_many :event_applications, as: :applicable
    has_many :favorites, as: :favoriterable
    has_many :notifications, as: :notifiable
    has_many :event_memberships_as_owner_or_performer, -> { as_owner_or_performer }, as: :memberable, source: 'event_membership', class_name: 'EventMembership'
    has_many :reviews, as: :reviewable, source: 'review'
    has_many :reviews_given, as: :reviewerable, source: 'review', class_name: 'Review'
    has_many :message_thread_participants, as: :entity
    has_many :message_threads, through: :message_thread_participants
    has_many :message_participants, as: :entity
    has_many :messages, through: :message_participants

    scope :active, -> { where(workflow_state: :active) }
    scope :with_user_as_member, -> (user_id) { where("EXISTS (SELECT 1 FROM entity_users eu WHERE eu.userable_type = '#{name}' AND eu.userable_id = #{quoted_table_name}.#{quoted_primary_key} AND eu.user_id = #{user_id} LIMIT 1)") }

    def class_type
      self.class.to_s
    end

    def favorite_entities
      self.favorites.includes(:favoritable).map(&:favoritable)
    end

    def favorited_by
      Favorite.where(favoritable: self).includes(:favoriterable).map(&:favoriterable)
    end

    def give_review(entity, text, rating)
      Review.find_or_create_by!(reviewerable: self, reviewable: entity, text: text, rating: rating)
    end

    def add_to_favorites(entity, text, rating)
      Favorite.find_or_create_by!(favoriterable: self, favoritable: entity)
    end

    def apply_to_event(event, status)
      EventApplication.find_or_create_by!(applicable: self, event_id: event.id, status: status)
    end

    def invite_to_event(event, invitee, status = 'pending', workflow_state = 'invitation')
      #TODO only make this possible if band is the owner of the event
      EventMembershp.find_or_create_by!(event_id: event.id, memberable: invitee, status: status, workflow_state: workflow_state)
    end

    def add_user(user)
      return if self.class.to_s == "User"
      EntityUser.find_or_create_by!(user: user, userable: self)
    end

    def events_as_performer
      memberships = event_memberships.where(role: 'performer').includes(:event)
      memberships.map(&:event)
    end

    def events_as_owner
      memberships = event_memberships.where(role: 'owner').includes(:event)
      memberships.map(&:event)
    end

    def events_as_attendee
      memberships = event_memberships.where(role: 'attendee').includes(:event)
      memberships.map(&:event)
    end

    def entity_user_for_user(user)
      entity_users.find_by(user_id: user)
    end

  end
end
