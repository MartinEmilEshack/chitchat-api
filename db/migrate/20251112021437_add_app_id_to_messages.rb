class AddAppIdToMessages < ActiveRecord::Migration[7.2]
  def change
    add_column :messages, :app_id, :integer
    add_index :messages, :app_id
  end
end
