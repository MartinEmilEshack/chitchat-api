class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats, if_not_exists: true do |t|
      t.integer :num, null: false
      t.integer :message_count, default: 0
      t.references :app, index: true, foreign_key: { to_table: :apps }, null: false

      t.timestamps
    end
  end
end
