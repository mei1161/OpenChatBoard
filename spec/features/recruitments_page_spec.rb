require 'rails_helper'

describe 'Recruitments' , js: true do
  specify 'ShowRecruitments' do
    visit '/recruitments'
    page.save_screenshot("ShowRecruitments-#{DateTime.now}.png")
    expect(page).to have_css('p',text: 'Test Room')
  end
end
