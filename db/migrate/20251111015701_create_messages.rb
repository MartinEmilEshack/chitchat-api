class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.integer :num, null: false
      t.text :text, null: false
      t.references :chat, index: true, foreign_key: { to_table: :chats }, null: false

      t.timestamps
    end
  end
end
