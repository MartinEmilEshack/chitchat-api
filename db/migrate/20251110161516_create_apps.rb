class CreateApps < ActiveRecord::Migration[5.2]
  def change
    create_table :apps, if_not_exists: true do |t|
      t.string :name
      t.string :token
      t.integer :chat_count

      t.timestamps
    end
  end
end
