class CreateMessageThreadParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :message_thread_participants do |t|
      t.references :message_thread, foreign_key: true
      t.integer :entity_id
      t.string :entity_type
      t.string :workflow_state
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :message_thread_participants, [:entity_id, :entity_type]
    add_index :message_thread_participants, :deleted_at
  end
end
