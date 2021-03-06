class CreateVotingTypes < ActiveRecord::Migration
  def self.up
    create_table :voting_types, :primary_key => :voting_type_id do |t|
      t.integer :tournament_id
      t.string :name
      t.integer :max_votes
      t.date :start_date
      t.date :end_date
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :voting_types
  end
end
