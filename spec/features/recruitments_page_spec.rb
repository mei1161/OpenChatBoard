require 'rails_helper'

feature 'Recruitments' , js: true do
  # Create a new recruitment and return a new recruitment
  def recruit(openchat_name:, invite_url:,description:,password:)
    visit '/recruitments'
    click_on 'Create Recruitment'
    fill_in 'OpenChat name',with: openchat_name
    fill_in 'Invite URL',with: invite_url
    fill_in 'Description',with: description
    fill_in 'Password',with: password
    click_on 'Recruit'

    recruitment = find_recruitment(openchat_name:openchat_name)
  end

  def find_recruitment(openchat_name:)
    name = find('.recruitment__openchat-name',text: openchat_name)
    recruitment = name.find(:xpath,"..")
    return recruitment
  end

  #Show-recruitment

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

  #Edit-recruitment

  scenario 'EditRecruitment' do
    openchat_name = "testchat2"
    invite_url = "https://line.me/ti/g2/EUz"
    description = "aaaa"
    password = "123"

    before_edit = recruit(
      openchat_name:openchat_name,
      invite_url:invite_url,
      description:description,
      password:password)

    page.save_screenshot("EditRecruitment-#{DateTime.now}.png")
    within(before_edit) do
      expect(page).to have_css('.recruitment__openchat-name',text: openchat_name)
      expect(page).to have_css('.recruitment__description',text: description)
    end

    within(before_edit) do
      click_on 'Edit'
    end

    fill_in 'Description',with: "aa"
    fill_in 'Password',with: password
    click_on 'Edit'


    edit_after = find_recruitment(openchat_name:openchat_name)

    within(edit_after) do
      page.save_screenshot("Edit_After-#{DateTime.now}.png")
      expect(page).to have_css('.recruitment__openchat-name',text: openchat_name)
      expect(page).to have_css('.recruitment__description',text: "aa")
    end
  end


  #Edit with Wrong Password test

  scenario 'Edit_with_wrong_password' do
    openchat_name = "testchat2"
    invite_url = "https://line.me/ti/g2/EUz"
    description = "aaaa"
    correct_password = "123"
    wrong_password = "345"

    before_edit = recruit(
      openchat_name:openchat_name,
      invite_url:invite_url,
      description:description,
      password:correct_password)

    page.save_screenshot("EditRecruitment-#{DateTime.now}.png")
    within(before_edit) do
      expect(page).to have_css('.recruitment__openchat-name',text: openchat_name)
      expect(page).to have_css('.recruitment__description',text: description)
    end

    within(before_edit) do
      click_on 'Edit'
    end

    fill_in 'Description',with: "aa"
    fill_in 'Password',with: wrong_password 
    click_on 'Edit'

    expect(page).to have_text("Password invalid")
  end

  #destroy-test

  scenario 'DestroyRecruitment' do
    openchat_name = "testchat2"
    invite_url = "https://line.me/ti/g2/EUz"
    description = "aaaa"
    password = "123"

    before_destroy = recruit(
      openchat_name:openchat_name,
      invite_url:invite_url,
      description:description,
      password:password)

    page.save_screenshot("EditRecruitment-#{DateTime.now}.png")
    within(before_destroy) do
      expect(page).to have_css('.recruitment__openchat-name',text: openchat_name)
      expect(page).to have_css('.recruitment__description',text: description)
    end

    within(before_destroy) do
      click_on 'Edit'
    end

    fill_in 'Password for deletion',with: password
    click_on 'Delete'

    expect(page).to have_no_css('.recruitment__openchat-name')
  end

  #destroy with wrong password

  scenario 'Destroy_with_wrong_password' do
    openchat_name = "testchat2"
    invite_url = "https://line.me/ti/g2/EUz"
    description = "aaaa"
    correct_password = "123"
    wrong_password = "345"

    before_edit = recruit(
      openchat_name:openchat_name,
      invite_url:invite_url,
      description:description,
      password:correct_password)

    page.save_screenshot("EditRecruitment-#{DateTime.now}.png")
    within(before_edit) do
      expect(page).to have_css('.recruitment__openchat-name',text: openchat_name)
      expect(page).to have_css('.recruitment__description',text: description)
    end

    within(before_edit) do
      click_on 'Edit'
    end

    fill_in 'Description',with: "aa"
    fill_in 'Password',with: wrong_password 
    click_on 'Delete'

    expect(page).to have_text("Password invalid")
  end

  # Recruitment_Comment test

  scenario 'CommentTest' do
    openchat_name = "test"
    invite_url = "https://line.me/ti/g2/EUz"
    description = "aaaa"
    password = "123"
    comment = "this is a pen"

    before_comment = recruit(
      openchat_name:openchat_name,
      invite_url:invite_url,
      description:description,
      password:password)

    page.save_screenshot("BeforeComment-#{DateTime.now}.png")

    within( before_comment ) do
      fill_in 'Comment',with: comment 
      fill_in 'Comment Password',with: password
      click_on 'Comment'
    end

    with_in(before_comment) do
      expect(page).to have_css('.recruitment__comment',text: comment) 
    end
    
  end
end
