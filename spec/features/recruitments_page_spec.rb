require 'rails_helper'

feature 'Recruitments' , js: true do
  #
  # Look for a recruitment for a specified open chat name.
  # 
  def find_recruitment(openchat_name:)
    name = find('.recruitment__openchat-name', text: openchat_name)
    return name.find(:xpath,"..")
  end

  # 
  # Create a new recruitment and return a new recruitment
  #
  def recruit(openchat_name:, invite_url:, description: ,password:)
    visit '/recruitments'
    click_on 'Create Recruitment'
    fill_in 'OpenChat name', with: openchat_name
    fill_in 'Invite URL', with: invite_url
    fill_in 'Description', with: description
    fill_in 'Password', with: password
    click_on 'Recruit'

    return find_recruitment openchat_name: openchat_name
  end

  # 
  # Search comments for the specified text in the recruitment
  #
  def find_comment(comment:)
    comment_text = find('.recruitment__comment', text: comment)
    return comment_text.find(:xpath,"..")
  end

  # 
  # Create a comment for the specified recruitment and return the comment
  #
  def comment_on(comment:, password:)
    fill_in 'Comment', with: comment 
    fill_in 'Comment Password', with: password
    click_on 'Comment'

    return find_comment comment: comment
  end
  
  #
  # Find a reply for a specified comment 
  #
  def find_comment_with_parent(parent:, comment:)
    within parent do
      comment_text = find('.recruitment__comment--reply', text: comment)
      return comment_text.find(:xpath,"..")
    end
  end

  # 
  # Reply to the specified recruitment comment and return the reply 
  #
  def reply_to(target:, text:, password:) 
    within target do
      click_on 'Reply'

      within find('form') do
        fill_in 'Reply', with: text
        fill_in 'Reply Password', with: password
        click_on 'Reply'
      end
    end
    
    find_comment_with_parent parent: target, comment: text
  end

  #
  # Show-recruitment
  #
  scenario 'ShowRecruitments' do
    openchat_name ="testchat"
    invite_url = "https://line.me/ti/g2/EUz"
    description = "aa"
    password = "abcde"

    result = 
      recruit openchat_name: openchat_name,
        invite_url: invite_url,
        description: description,
        password: password

    visit '/recruitments'
    page.save_screenshot("ShowRecruitments-#{DateTime.now}.png")

    within result do
      click_on 'Join'
    end

    expect(page).to have_title "LINE OPENCHAT"
    page.save_screenshot("ShowRecruitments_Clicked_join-#{DateTime.now}.png")
  end

  #
  # Edit-recruitment with correct_password
  #

  scenario 'EditRecruitment' do
    openchat_name = "testchat2"
    invite_url = "https://line.me/ti/g2/EUz"
    description = "aaaa"
    password = "123"

    recruitment_before_edit = 
      recruit openchat_name: openchat_name,
        invite_url: invite_url,
        description: description,
        password: password

    page.save_screenshot("EditRecruitment-#{DateTime.now}.png")

    within recruitment_before_edit do
      click_on 'Edit'
    end

    fill_in 'Description', with: "aa"
    fill_in 'Password', with: password
    click_on 'Edit'

    recruitment_after_edit = 
      find_recruitment openchat_name: openchat_name

    within recruitment_after_edit do
      page.save_screenshot("Edit_After-#{DateTime.now}.png")
      expect(page).to have_css('.recruitment__openchat-name', text: openchat_name)
      expect(page).to have_css('.recruitment__description', text: "aa")
    end
  end


  #
  # Edit with Wrong Password test
  #
  scenario 'Edit_with_wrong_password' do
    openchat_name = "testchat2"
    invite_url = "https://line.me/ti/g2/EUz"
    description = "aaaa"
    correct_password = "123"
    wrong_password = "345"

    recruitment_before_edit = 
      recruit openchat_name: openchat_name,
        invite_url: invite_url,
        description: description,
        password: correct_password

    page.save_screenshot("EditRecruitment-#{DateTime.now}.png")

    within recruitment_before_edit do
      click_on 'Edit'
    end

    fill_in 'Description',with: "aa"
    fill_in 'Password', with: wrong_password 
    click_on 'Edit'

    expect(page).to have_text("Password invalid")
  end

  #
  # destroy-test
  #
  scenario 'DestroyRecruitment' do
    openchat_name = "testchat2"
    invite_url = "https://line.me/ti/g2/EUz"
    description = "aaaa"
    password = "123"

    recruitment_before_destroy = 
      recruit openchat_name: openchat_name,
        invite_url: invite_url,
        description: description,
        password: password

    page.save_screenshot("EditRecruitment-#{DateTime.now}.png")

    within recruitment_before_destroy do
      click_on 'Edit'
    end

    fill_in 'Password for deletion', with: password
    click_on 'Delete'

    expect(page).to have_no_css('.recruitment__openchat-name')
  end

  #
  # destroy with wrong password
  #
  scenario 'Destroy_with_wrong_password' do
    openchat_name = "testchat2"
    invite_url = "https://line.me/ti/g2/EUz"
    description = "aaaa"
    correct_password = "123"
    wrong_password = "345"

    recruitment_before_edit = 
      recruit openchat_name: openchat_name,
      invite_url: invite_url,
      description: description,
      password: correct_password

    page.save_screenshot("EditRecruitment-#{DateTime.now}.png")

    within recruitment_before_edit do
      click_on 'Edit'
    end

    fill_in 'Description', with: "aa"
    fill_in 'Password', with: wrong_password 
    click_on 'Delete'

    expect(page).to have_text("Password invalid")
  end

  # 
  # Recruitment_Comment test
  #

  scenario 'CommentTest' do
    openchat_name = "test"
    invite_url = "https://line.me/ti/g2/EUz"
    description = "aaaa"
    password = "123"
    comment = "this is a pen"

    recruitment_before_comment = 
      recruit openchat_name: openchat_name,
        invite_url: invite_url,
        description: description,
        password: password

    page.save_screenshot("BeforeComment-#{DateTime.now}.png")

    within recruitment_before_comment do
      comment_on comment: comment, password: password
      expect(page).to have_css('.recruitment__comment', text: comment) 
    end

  end

  #
  # Delete related comments by deleting recruitment 
  #
  scenario 'Relation Test' do
    openchat_name = "test"
    invite_url = "https://line.me/ti/g2/EUz"
    description = "aaaa"
    password = "123"
    comment = "this is a pen"

    recruitment_before_comment =
      recruit openchat_name: openchat_name,
        invite_url: invite_url,
        description: description,
        password: password

    page.save_screenshot("AfterComment-#{DateTime.now}.png")

    within recruitment_before_comment do
      comment_on comment: comment, password: password
      click_on 'Edit'
    end

    fill_in 'Password for deletion', with: password
    click_on 'Delete'

    expect(page).to have_no_css('.recruitment__comment')
  end


  #
  # Test reply to comment 
  #
  scenario 'ReplyTest' do
    openchat_name = "test"
    invite_url = "https://line.me/ti/g2/EUz"
    description = "aaaa"
    password = "123"
    comment = "this is a pen"
    reply = "HelloWorld"

    recruitment_before_comment =
      recruit openchat_name: openchat_name,
        invite_url: invite_url,
        description: description,
        password: password

    page.save_screenshot("BeforeComment-#{DateTime.now}.png")

    within recruitment_before_comment do
      target_comment = comment_on comment: comment, password: password
      target_reply = 
        reply_to target: target_comment, 
          text: reply, 
          password: password

      within target_reply do
        expect(page).to have_css('.recruitment__comment--reply', text: reply)
      end
    end

  end
end
