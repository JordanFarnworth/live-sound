class RemoveStatusFromEventMemberships < ActiveRecord::Migration[5.0]
  def change
    remove_column :event_memberships, :status
  end
end
