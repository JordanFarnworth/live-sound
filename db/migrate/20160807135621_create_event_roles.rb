class CreateEventRoles < ActiveRecord::Migration[5.0]
  def change
    remove_column :event_members, :member_type, :string
    add_column :event_members, :role, :string
    remove_column :event_invitations, :invitation_type, :string
    add_column :event_invitations, :role, :string
    add_index :event_members, :role
    add_index :event_invitations, :role
  end
end
