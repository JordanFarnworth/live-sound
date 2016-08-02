class Favorite < ApplicationRecord
  belongs_to :favoriterable, polymorphic: true
  belongs_to :favoritable, polymorphic: true
end
