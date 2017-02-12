require 'rails_helper'

describe "Beers page" do

  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }

  it "allows to make a new beer" do
    visit new_beer_path
    fill_in('beer_name', with:"Karhu")
    select brewery.name, :from => 'beer[brewery_id]'
    
    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end

  it "shows error-msg when invalid beer added" do
    visit new_beer_path
    fill_in('beer_name', with:"")
    select brewery.name, :from => 'beer[brewery_id]'
    click_button "Create Beer"

    expect(page).to have_content "Name can't be blank"
  end

end