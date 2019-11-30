require 'rails_helper'

feature 'Recruitments' , js: true do
  scenario 'ShowRecruitments' do
    visit '/recruitments/new'
    fill_in 'OpenChat name', with: 'testchat'
    fill_in 'Invite URL',with: 'https://line.me/ti/g2/EUz'
    fill_in 'Description',with: 'aa'
    click_on 'Recruit'

    visit '/recruitments'
    page.save_screenshot("ShowRecruitments-#{DateTime.now}.png")
    expect(page).to have_css('.recruitment__openchat-name',text: 'testchat')
    expect(page).to have_css('.recruitment__description',text:'aa')
    text = find('.recruitment__openchat-name',text:'testchat')
  end
end
