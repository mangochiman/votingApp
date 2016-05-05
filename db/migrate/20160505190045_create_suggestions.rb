class CreateSuggestions < ActiveRecord::Migration
  def self.up
    create_table :suggestions, :primary_key => :suggestion_id do |t|
      t.string :title
      t.string :data
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :suggestions
  end
end
