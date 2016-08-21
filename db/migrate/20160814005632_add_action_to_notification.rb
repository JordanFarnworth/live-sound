class AddActionToNotification < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :action, :text
  end
end
