class Claim < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :user
end