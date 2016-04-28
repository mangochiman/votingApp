class CreateTournamentParticipants < ActiveRecord::Migration
  def self.up
    create_table :tournament_participants do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :tournament_participants
  end
end
