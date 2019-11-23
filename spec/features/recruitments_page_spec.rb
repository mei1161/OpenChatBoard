require 'rails_helper'

feature 'Recruitments' , js: true do
  scenario 'ShowRecruitments' do
    visit '/recruitments/new'
    fill_in 'Room Name', with: 'asansroom'
    click 'Recruit'

    visit '/recruitments'
    page.save_screenshot("ShowRecruitments-#{DateTime.now}.png")
    expect(page).to have_css('p',text: 'asansroom')
  end
end
