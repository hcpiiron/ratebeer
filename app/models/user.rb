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

	def favorite_beer
	  return nil if ratings.empty?
	  ratings.order(score: :desc).limit(1).first.beer  #optimaalisin
      #ratings.sort_by{ |r| r.score }.last.beer      tämä käy myös
      #ratings.sort_by(&:score).last.beer   tämä käy myös
  	end

  	def favorite_style
      return favorite_beer_feature(:style)
    end

    def favorite_brewery
      return favorite_beer_feature(:brewery)
    end

    def favorite_beer_feature(feature)
      return nil if ratings.empty?
      grouped = ratings.group_by{|x| x.beer.send(feature)}
      grouped.each_pair{|k, v| grouped[k] = v.sum(&:score) / v.size.to_f}
      grouped.sort_by{|k, v| v}.last[0]
    end

    



  end

end
