FactoryGirl.define do
  factory :entity_user, class: EntityUser do
    association :user, factory: :user
    association :userable, factory: :user
    workflow_state 'active'
  end
end
