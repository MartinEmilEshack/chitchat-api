class RemoveTokenAndAddRedisHostToApp < ActiveRecord::Migration[5.2]
  def up
    add_column :apps, :redis_host, :integer, if_not_exists: true
    remove_column :apps, :token if column_exists?(:apps, :token)
  end

  def down
    remove_column :apps, :redis_host if column_exists?(:apps, :redis_host)
    add_column :apps, :token, :string, if_not_exists: true
  end
end
