class CreateTournamentParticipants < ActiveRecord::Migration
  def self.up
    create_table :tournament_participants, :id => false do |t|
      t.integer :user_id
      t.integer :tournament_id
      t.timestamps
    end
  end

  def self.down
    drop_table :tournament_participants
  end
end
