class Review < ApplicationRecord
  belongs_to :reviewable, polymorphic: true
  belongs_to :reviewerable, polymorphic: true
end
