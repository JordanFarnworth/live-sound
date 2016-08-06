class AddInvitationTypeToEventInvitation < ActiveRecord::Migration[5.0]
  def change
    add_column :event_invitations, :invitation_type, :string
    add_column :event_applications, :application_type, :string
    add_column :event_invitations, :deleted_at, :datetime, index: true
  end
end
