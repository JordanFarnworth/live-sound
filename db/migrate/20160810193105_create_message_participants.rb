class CreateMessageParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :message_participants do |t|
      t.references :message, foreign_key: true
      t.integer :entity_id
      t.string :entity_type
      t.string :workflow_state
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :message_participants, [:entity_id, :entity_type]
    add_index :message_participants, :deleted_at
  end
end
