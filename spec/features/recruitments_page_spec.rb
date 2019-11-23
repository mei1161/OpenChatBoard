require 'rails_helper'

feature 'Recruitments' , js: true do
  scenario 'ShowRecruitments' do
    visit '/recruitments'
    page.save_screenshot("ShowRecruitments-#{DateTime.now}.png")
    expect(page).to have_css('p',text: 'Test Room')
  end
end
