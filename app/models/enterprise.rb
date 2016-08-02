class Enterprise < ApplicationRecord
  include Entityable

  acts_as_paranoid

  serialize :settings, Hash
  serialize :social_media, Hash
end
