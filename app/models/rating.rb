class Rating < ActiveRecord::Base
	belongs_to :beer
	belongs_to :user

	validates :score, numericality: { greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 50,
                                    only_integer: true }

	def to_s
		((Beer.find_by id: self.beer_id).name + " #{self.score}")
	end
end