class CreateMessageThreads < ActiveRecord::Migration[5.0]
  def change
    create_table :message_threads do |t|
      t.string :subject
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :message_threads, :deleted_at
  end
end
