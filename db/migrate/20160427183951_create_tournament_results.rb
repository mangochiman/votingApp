class CreateTournamentResults < ActiveRecord::Migration
  def self.up
    create_table :tournament_results, :primary_key => :tournament_result_id do |t|
      t.integer :tournament_id
      t.integer :participant_id
      t.string :result
      t.timestamps
    end
  end

  def self.down
    drop_table :tournament_results
  end
end
