class Team < ApplicationRecord
  belongs_to :user

  has_many :player_team_relationships
  has_many :players, :through => :player_team_relationships
  
  has_many :matches
end
