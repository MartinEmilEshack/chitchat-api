class ChangeAttributesConstrains < ActiveRecord::Migration[5.2]
  def up
    change_column :apps, :name, :string, :null => false
    change_column :apps, :chat_count, :integer, :default => 0
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't remove the default"
  end
end
