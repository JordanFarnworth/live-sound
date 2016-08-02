class PrivateParty < ApplicationRecord
  include Entityable

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  has_many :events, as: :memberable, through: :event_members
  has_many :event_members, as: :memberable

  acts_as_paranoid

  serialize :settings, Hash
  serialize :social_media, Hash

end
