class PrivateParty < ApplicationRecord
  include Entityable

  has_many :events, as: :memberable, through: :event_members
  has_many :event_members, as: :memberable

  acts_as_paranoid

  serialize :settings, Hash
  serialize :social_media, Hash

end
