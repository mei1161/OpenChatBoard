require 'rails_helper'

describe 'Postpage' , js: true do
  specify 'DisplayGreeting' do
    visit '/'
    page.save_screenshot("DisplayGreeting-#{DateTime.now}.png")
    expect(page).to have_css('p',text: 'Top')
  end
end
