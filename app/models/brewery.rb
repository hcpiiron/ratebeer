class Brewery < ActiveRecord::Base
	include RatingAverage

	has_many :beers,  dependent: :destroy
	has_many :ratings, through: :beers

	validates :name, presence: true
    validates_numericality_of :year, { greater_than_or_equal_to: 1042, 
                                      less_than_or_equal_to: lambda {|_| Time.now.year}, 
                                      only_integer: true }

end

