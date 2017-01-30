class Membership < ActiveRecord::Base
	belongs_to :user
  	belongs_to :beer_club

  	validates :user_id, uniqueness: true

end
