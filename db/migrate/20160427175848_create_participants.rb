class CreateParticipants < ActiveRecord::Migration
  def self.up
    create_table :participants, :primary_key => :participant_id do |t|
      t.string :nick_name
      t.string :first_name
      t.string :last_name
      t.binary :picture
      t.integer :elo
      t.timestamps
    end
  end

  def self.down
    drop_table :participants
  end
end
