class CreateTrackers < ActiveRecord::Migration
  def self.up
    create_table :trackers, :primary_key => :tracker_id do |t|
      t.integer :user_id
      t.string :ip_address
      t.timestamps
    end
  end

  def self.down
    drop_table :trackers
  end
end
