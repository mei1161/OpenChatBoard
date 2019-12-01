require 'rails_helper'

feature 'Recruitments' , js: true do
  # Create a new recruitment and return a new recruitment
  def recruit(openchat_name:, invite_url:,description:,password:)
    visit '/recruitments/new'
    fill_in 'OpenChat name',with: openchat_name
    fill_in 'Invite URL',with: invite_url
    fill_in 'Description',with: description
    fill_in 'Password',with: password
    click_on 'Recruit'

    openchat_name = find('.recruitment__openchat-name',text: openchat_name)
    recruitment =openchat_name.find(:xpath,"..")
    return recruitment
  end

  scenario 'ShowRecruitments' do
    openchat_name ="testchat"
    invite_url = "https://line.me/ti/g2/EUz"
    description = "aa"
    password = "abcde"

    result = recruit(
      openchat_name:openchat_name,
      invite_url:invite_url,
      description:description,
      password:password)

    visit '/recruitments'
    page.save_screenshot("ShowRecruitments-#{DateTime.now}.png")

    within(result) do
      expect(page).to have_css('.recruitment__openchat-name',text: openchat_name)
      expect(page).to have_css('.recruitment__description',text: description)
    end
    
    within(result) do
      click_on 'Join'
    end

    expect(page).to have_title "LINE OPENCHAT"
    page.save_screenshot("ShowRecruitments_Clicked_join-#{DateTime.now}.png")
  end

  scenario 'EditRecruitment' do
    openchat_name = "testchat2"
    invite_url = "https://line.me/ti/g2/EUz"
    description = "aa"
    password = "123"

    result = recruit(
      openchat_name:openchat_name,
      invite_url:invite_url,
      description:description,
      password:password)

    page.save_screenshot("EditRecruitment-#{DateTime.now}.png")
    within(result) do
      expect(page).to have_css('.recruitment__openchat-name',text: openchat_name)
      expect(page).to have_css('.recruitment__description',text: description)
    end

    within(result) do
      click_on 'Edit'
    end

    within(result) do
      expect(page).to have_css('.recruitment__openchat-name',text: openchat-name)
    end
    fill_in 'Description',with: "aa"
    fill_in 'Password',with: password
    click_on 'Recruit'

    within(result) do
      expect(page).to have_css('.recruitment__openchat-name',text: openchat-name)
      expect(page).to have_css('.recruitment__openchat-description',text: "aa")
    end
  end
end
