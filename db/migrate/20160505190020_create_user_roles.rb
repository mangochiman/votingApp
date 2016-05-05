class CreateUserRoles < ActiveRecord::Migration
  def self.up
    create_table :user_roles, :id => false do |t|
      t.integer :user_id
      t.string :role
      t.timestamps
    end
  end

  def self.down
    drop_table :user_roles
  end
end
