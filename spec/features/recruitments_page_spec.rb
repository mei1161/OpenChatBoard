require 'rails_helper'

feature 'Recruitments' , js: true do
  scenario 'ShowRecruitments' do
    visit '/recruitments/new'
    fill_in 'Room Name', with: 'asansroom'
    fill_in 'URL',with: 'aaaa'
    fill_in 'Description',with: 'aa'
    click_on 'Recruit'

    visit '/recruitments'
    page.save_screenshot("ShowRecruitments-#{DateTime.now}.png")
    expect(page).to have_css('p',text: 'asansroom','p',text:'aaaa','p',:text:'aa')
  end
end
