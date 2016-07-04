class Competition < ActiveRecord::Base
  #replica of voting type
  set_table_name :voting_types
  set_primary_key :voting_type_id

  has_many :votes, :foreign_key => :voting_type_id
  belongs_to :tournament, :foreign_key => :tournament_id
  has_many :prediction_winners, :foreign_key => :competition_id, :primary_key => :voting_type_id
  
  def total_voters
    voters =  self.votes.find(:all, :group => 'user_id')
    return voters
  end
  
end
