require 'rails_helper'

RSpec.describe Beer, type: :model do
  
  it "is created and saved with proper name and style" do
  	beer = Beer.create name:"kalja", style:"IPA"
  	expect(beer.valid?).to be(true)
  	expect(Beer.count).to eq(1)
  end
  
  it "is not saved without a name" do
  	beer = Beer.create
  	expect(beer.valid?).to be(false)
  end
  
  it "is not saved without a style" do
  	beer = Beer.create name:"kalja"
  	expect(beer.valid?).to be(false)
  end

end