class DropEntityInvitation < ActiveRecord::Migration[5.0]
  def change
    drop_table :event_invitations
    rename_table :event_members, :event_memberships
    add_column :event_memberships, :status, :string
  end
end
