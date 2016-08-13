class CreateEventRoles < ActiveRecord::Migration[5.0]
  def change
    remove_column :event_members, :member_type, :string
    add_column :event_members, :role, :string
    remove_column :event_invitations, :invitation_type, :string
    add_column :event_invitations, :role, :string
    add_index :event_members, :role
    add_index :event_invitations, :role
    add_index :event_members, [:memberable_id, :memberable_type, :role], unique: true, name: 'index_event_members_on_memberable_id_type_role'
    add_index :event_invitations, [:invitable_id, :invitable_type, :role], unique: true, name: 'index_event_invitations_on_invitable_id_type_role'
  end
end
