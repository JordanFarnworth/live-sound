class FixWorkflowState < ActiveRecord::Migration[5.0]
  def change
    remove_column :bands, :state, :string
    add_column :bands, :workflow_state, :string
  end
end
