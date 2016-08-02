class EntityUser < ApplicationRecord
  belongs_to :user
  belongs_to :userable, polymorphic: :true
end
