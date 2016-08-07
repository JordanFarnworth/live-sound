class CreateJwtSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :jwt_sessions do |t|
      t.references :user, foreign_key: true
      t.string :jwt_id

      t.timestamps
    end
    add_index :jwt_sessions, :jwt_id
  end
end
