class Team < ApplicationRecord
  belongs_to :user
  belongs_to :league

  has_many :player_team_relationships
  has_many :players, :through => :player_team_relationships

  has_many :matches
end
