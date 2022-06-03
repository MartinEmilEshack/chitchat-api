class RemoveTokenAndAddRedisHostToApp < ActiveRecord::Migration[5.2]
  def up 
    add_column :apps, :redis_host, :integer
    remove_column :apps, :token
  end

  def down 
    remove_column :apps, :redis_host
    add_column :apps, :token, :string
  end
end
