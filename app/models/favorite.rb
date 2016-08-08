class Favorite < ApplicationRecord
  belongs_to :favoriterable, polymorphic: true
  belongs_to :favoritable, polymorphic: true

  validates :favoriterable_type, presence: true, inclusion: Entityable::ENTITYABLE_CLASSES, uniqueness: { scope: [:favoriterable_id, :favoritable_type, :favoritable_id] }
  validates :favoriterable_id, presence: true
  validates :favoritable_type, presence: true, inclusion: Entityable::ENTITYABLE_CLASSES
  validates :favoritable_id, presence: true
  validates :favoriterable, presence: true
  validates :favoritable, presence: true

  def self.build_favorite(favoritable, favoriterable)
    Favorite.find_or_initialize_by(favoritable: favoritable, favoriterable: favoriterable)
  end
end
