class League < ApplicationRecord
  has_many :teams
  has_many :users
  has_many :matches
  has_many :bids

<<<<<<< Updated upstream
  validates :season, presence: true, length: { maximum: 20 }
  validates :name, presence: true, length: { maximum: 25 }
=======
  validates :season, :presence => true, :length => { :maximum => 20 }
  validates :name, :presence => true, :length => { :maximum => 25 }
>>>>>>> Stashed changes
end
