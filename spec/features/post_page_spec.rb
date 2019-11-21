require 'rails_helper'

describe 'Postpage' do
  specify 'DisplayGreeting' do
    visit '/'
    expect(page).to have_css('p',text: 'HelloWorld')
  end
end
