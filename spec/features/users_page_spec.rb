require 'rails_helper'

include Helpers

describe "User" do
  #before :each do
   # FactoryGirl.create :user
  #end

  let!(:brewery) { FactoryGirl.create :brewery, :name => "Koff" }
  let!(:beer1) { FactoryGirl.create :beer, :name => "iso 3", :brewery => brewery }
  let!(:user) { FactoryGirl.create :user }
  let!(:user2) { FactoryGirl.create :user, :username => "Jorma" }

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  it "when signed in can see only own ratings" do
    sign_in(username:"Jorma", password:"Foobar1")
    rating3 = FactoryGirl.create :rating, :beer => beer1, :user => user2, :score => 44
    click_link "Signout"

    sign_in(username:"Pekka", password:"Foobar1")
    rating = FactoryGirl.create :rating, :beer => beer1, :user => user, :score => 10
    rating2 = FactoryGirl.create :rating, :beer => beer1, :user => user, :score => 15
    visit user_path(user)
    expect(page).to have_content("#{beer1.name} #{rating.score}")
    expect(page).to have_content("#{beer1.name} #{rating2.score}")
    expect(page).to have_no_content("#{beer1.name} #{rating3.score}")
  end




end