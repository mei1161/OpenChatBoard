require 'rails_helper'

feature 'Recruitments' , js: true do
  scenario 'ShowRecruitments' do
    visit '/recruitments/new'
    fill_in 'Room Name', with: 'testchat'
    fill_in 'URL',with: 'https://line.me/ti/g2/EUz'
    fill_in 'Description',with: 'aa'
    click_on 'Recruit'

    visit '/recruitments'
    page.save_screenshot("ShowRecruitments-#{DateTime.now}.png")
    expect(page).to have_css('p',text: 'testchat')
  end
end
