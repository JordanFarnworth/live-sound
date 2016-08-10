class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.references :message_thread, foreign_key: true
      t.text :body
      t.integer :author_id
      t.string :author_type
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :messages, [:author_id, :author_type]
    add_index :messages, :deleted_at
  end
end
