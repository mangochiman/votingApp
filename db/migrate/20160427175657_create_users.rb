class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :primary_key => :user_id do |t|
      t.string :phone_number
      t.string :nick_name
      t.string :first_name
      t.string :last_name
      t.string :password
      t.string :salt
      t.binary :picture
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
