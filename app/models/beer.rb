class Beer < ActiveRecord::Base
	belongs_to :brewery
	has_many :ratings

	def average_rating
		list = Array.new
		ratings.each { |r| list.push(r.score)}
		sum = list.inject { |sum, n| sum + n }
		sum / ratings.count
	end

	def to_s
		
		(self.name + " brewed by " + brewery.name)
	end

end
