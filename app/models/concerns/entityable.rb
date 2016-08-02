module Entityable
  extend ActiveSupport::Concern

  included do

    # has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
    # validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
    has_many :users, through: :entity_users, as: :userable
    has_many :entity_users, as: :userable
    has_many :events, as: :memberable, through: :event_members
    has_many :event_members, as: :memberable
    has_many :events_applied_to, through: :event_applications, as: :applicable, source: "event"
    has_many :event_applications, as: :applicable
    has_many :event_invitations, as: :invitable
    has_many :events_invited_to, through: :event_invitations, as: :invitable, source: "event"
    has_many :favorites, as: :favoriterable
    has_many :notifications, as: :notifiable

    scope :active, -> { where(state: :active) }

    def class_type
      self.class.to_s
    end

    def reviews
      Review.where(reviewable: self)
    end

    def reviews_given
      Review.where(reviewerable: self)
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
      EventApplication.find_or_create_by!(applicable: self, event_id: event.id, state: 'pending', status: status)
    end

    def invite_to_event(event, invitee, status)
      #TODO only make this possible if band is the owner of the event
      EventInvitation.find_or_create_by!(event_id: event.id, invitable: invitee, state: 'pending', status: status)
    end

    def add_user(u, status= "")
      return if self.class.to_s == "User"
      EntityUser.find_or_create_by!(user: u, userable: self, state: 'active', status: status)
    end

    def events_as_performer
      memberships = event_members.where(member_type: 'performer').includes(:event)
      memberships.map(&:event)
    end

    def events_as_owner
      memberships = event_members.where(member_type: 'owner').includes(:event)
      memberships.map(&:event)
    end

    def events_as_attendee
      memberships = event_members.where(member_type: 'attendee').includes(:event)
      memberships.map(&:event)
    end

  end
end
