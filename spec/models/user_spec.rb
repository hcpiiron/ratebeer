require 'rails_helper'

RSpec.describe User, type: :model do

  it "has the username set correctly" do
  	user = User.new username:"Pekka"

  	expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
  	user = User.create username:"Pekka"

  	expect(user.valid?).to be(false)
  	expect(user).not_to be_valid
  	expect(User.count).to eq(0)
  end

   describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "is not proper or saved when" do

  	it "password is too short" do
  		user = User.create username: "Pekka", password: "a1", password_confirmation:"a1"
  		expect(User.count).to eq(0)
  		expect(user).not_to be_valid
  	end

  	it "password includes only letters" do
  		user = User.create username: "Pekka", password: "vainkirjaimia", password_confirmation:"vainkirjaimia"
  		expect(User.count).to eq(0)
  		expect(user).not_to be_valid
  	end
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(user, 10)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(user, 10, 20, 15, 7, 9)
      best = create_beer_with_rating(user, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryGirl.create :user }

    it "is nil if user has not rated any beers" do
      expect(user.favorite_style).to be(nil)
    end

    it "is style of the only rated beer" do
      create_beer_with_rating(user, 25)
      expect(user.favorite_style).to eq("Lager")
    end

    it "is style with highest average rating if several rated" do
      beer = Beer.new name: "test", style: "IPA"
      rating = Rating.new score: 10, beer: beer
      rating2 = Rating.new score: 600, beer: beer
      user.ratings << rating
      user.ratings << rating2

      beer2 = Beer.new name: "test2", style: "lolz"
      rating3 = Rating.new score: 10, beer: beer2
      rating4 = Rating.new score: 56, beer: beer2
      user.ratings << rating3
      user.ratings << rating4

      expect(user.favorite_style).to eq("IPA")
    end
  end




  describe "favorite breweries" do
    let(:user){ FactoryGirl.create :user }

    it "is nil if user has not rated any beers" do
      expect(user.favorite_brewery).to be(nil)
    end

    it "is brewery of the only rated beer" do
      brewery = FactoryGirl.create(:brewery)
      beer = Beer.new name: "test", style: "IPA"
      rating = Rating.new score: 10, beer: beer
      user.ratings << rating
      beer.brewery = brewery
      expect(user.favorite_brewery).to be(brewery)
    end

    it "is brewery with highest average rating if several rated" do
      brewery = FactoryGirl.create(:brewery)
      beer = Beer.new name: "test", style: "IPA"
      rating = Rating.new score: 10, beer: beer
      user.ratings << rating
      beer.brewery = brewery
      beer2 = Beer.new name: "test2", style: "IPA"
      rating2 = Rating.new score: 47, beer: beer2
      user.ratings << rating2
      beer2.brewery = brewery

      brewery2 = FactoryGirl.create(:brewery, name:"panimoX")
      beer3 = Beer.new name: "test3", style: "IPA"
      rating3 = Rating.new score: 10, beer: beer3
      user.ratings << rating3
      beer3.brewery = brewery2
      beer4 = Beer.new name: "test4", style: "IPA"
      rating4 = Rating.new score: 49, beer: beer4
      user.ratings << rating4
	  beer4.brewery = brewery2
      expect(user.favorite_brewery).to eq(brewery2)

    end
  end





end

def create_beer_with_rating(user, score)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings(user, *scores)
  scores.each do |score|
    create_beer_with_rating(user, score)
  end
end