class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :num, :null => false
      t.integer :message_count, :default => 0
      t.references :app, index: true, foreign_key: { to_table: :apps }

      t.timestamps
    end
  end
end
