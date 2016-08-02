class Band < ApplicationRecord
  include Entityable

  acts_as_paranoid

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  serialize :settings, Hash
  serialize :social_media, Hash

end
