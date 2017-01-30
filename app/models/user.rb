CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

class User < ActiveRecord::Base
	include RatingAverage

	has_secure_password

	validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }
	validates_length_of :password, :minimum => 4
	validate :good_password
	
	has_many :ratings, dependent: :destroy
	has_many :beers, through: :ratings
	has_many :memberships, dependent: :destroy
	has_many :beer_clubs, through: :memberships

	def to_s
		self.username
	end

	def good_password
    if password and password.chars.all? { |char| CHARS.include? char}
      errors.add(:password, "password can't have only characters")
    end
  end

end
