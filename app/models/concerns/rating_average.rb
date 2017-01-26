module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    list = Array.new
    ratings.each { |r| list.push(r.score)}
    sum = list.inject { |sum, n| sum + n }
    sum / ratings.count
  end

end
