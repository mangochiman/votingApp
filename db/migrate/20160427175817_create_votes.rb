class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes, :id => false do |t|
      t.integer :user_id
      t.integer :participant_id
      t.integer :voting_type_id
      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
