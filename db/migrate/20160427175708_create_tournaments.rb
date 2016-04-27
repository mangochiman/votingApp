class CreateTournaments < ActiveRecord::Migration
  def self.up
    create_table :tournaments, :primary_key => :tournament_id do |t|
      t.string :name
      t.string :start_date
      t.string :end_date
      t.string :sponsored_by
      t.timestamps
    end
  end

  def self.down
    drop_table :tournaments
  end
end
