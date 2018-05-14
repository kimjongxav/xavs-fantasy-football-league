class Team < ApplicationRecord
  belongs_to :user
  belongs_to :league

  has_many :players
  has_many :matches
end
