require 'rails_helper'

feature 'ShowPage' , js: true do
  scenario 'ShowRoomName' do
    visit '/recruitments'
    click_on 'test012'

    visit '/recruitments/43'
    page.save_screenshot("ShowRoomName-#{DateTime.now}.png")
    expect(page).to have_css('p',text: 'test012')
  end
end

