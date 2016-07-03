class CreatePredictionWinners < ActiveRecord::Migration
  def self.up
    create_table :prediction_winners do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :prediction_winners
  end
end
