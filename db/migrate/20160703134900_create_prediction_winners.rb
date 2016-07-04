class CreatePredictionWinners < ActiveRecord::Migration
  def self.up
    create_table :prediction_winners, :id => false do |t|
      t.integer :voter_id
      t.integer :competition_id
      t.integer :position
      t.timestamps
    end
  end

  def self.down
    drop_table :prediction_winners
  end
end
