class AddAppIdToMessages < ActiveRecord::Migration[7.2]
  def change
    add_column :messages, :app_id, :integer, if_not_exists: true
    add_index :messages, :app_id, if_not_exists: true
  end
end
