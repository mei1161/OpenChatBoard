require 'rails_helper'

feature 'Recruitments' , js: true do

  # 
  # Create a new recruitment and return a new recruitment
  #
  def recruit(openchat_name:, invite_url:, description:,password:)
    visit '/recruitments'
    click_on 'Create Recruitment'
    fill_in 'OpenChat name',with: openchat_name
    fill_in 'Invite URL',with: invite_url
    fill_in 'Description',with: description
    fill_in 'Password',with: password
    click_on 'Recruit'

    return find_recruitment(openchat_name:openchat_name)
  end

  #
  # Look for a recruitment for a specified open chat name.
  # 
  def find_recruitment(openchat_name:)
    name = find('.recruitment__openchat-name',text: openchat_name)
    return name.find(:xpath,"..")
  end


  # 
  # Create a comment for the specified recruitment and return the comment
  #
  def comment_on(recruitment:, comment:, password:)
    within recruitment do
      fill_in 'Comment',with: comment 
      fill_in 'Comment Password',with: password
      click_on 'Comment'

      return find_comment(recruitment:recruitment, comment:comment)
    end
  end
  

  # 
  # Search comments for the specified text in the recruitment
  #
  def find_comment(recruitment:, comment:)
    within recruitment do
     comment_text = find('recruitment__comment',text: comment)
     rerturn comment_text.find(:xpath,"..")
    end
  end


  # 
  # Reply to the specified recruitment comment and return the reply 
  #
  def reply_to(openchat_name:, target:, text:, password:)
    within target do
      fill_in 'Reply_Comment', with: text
      fill_in 'Reply Password', with: password
      click_on 'Reply'
    end

    target_recruitment = find_recruitment(openchat_name:openchat_name)
    target_comment = find_comment(recruitment:target_recruitment, text:text)
    find_reply(coment:target_comment, text: text)
  end

  #
  # Get a reply with specified criteria 
  #
  def find_reply(recruitment:, comment:, text:)
    within comment do
      reply_text = ('.comment__reply',text: text)
      return reply_text.find(xpath: "..")
    end
  end

  #
  # Show-recruitment
  #
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

    within result do
      expect(page).to have_css('.recruitment__openchat-name',text: openchat_name)
      expect(page).to have_css('.recruitment__description',text: description)
    end
    
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

    before_edit = recruit(
      openchat_name:openchat_name,
      invite_url:invite_url,
      description:description,
      password:password)

    page.save_screenshot("EditRecruitment-#{DateTime.now}.png")
    within before_edit do
      expect(page).to have_css('.recruitment__openchat-name',text: openchat_name)
      expect(page).to have_css('.recruitment__description',text: description)
    end

    within before_edit do
      click_on 'Edit'
    end

    fill_in 'Description',with: "aa"
    fill_in 'Password',with: password
    click_on 'Edit'


    edit_after = find_recruitment(openchat_name:openchat_name)

    within edit_after do
      page.save_screenshot("Edit_After-#{DateTime.now}.png")
      expect(page).to have_css('.recruitment__openchat-name',text: openchat_name)
      expect(page).to have_css('.recruitment__description',text: "aa")
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

    before_edit = recruit(
      openchat_name:openchat_name,
      invite_url:invite_url,
      description:description,
      password:correct_password)

    page.save_screenshot("EditRecruitment-#{DateTime.now}.png")
    within before_edit do
      expect(page).to have_css('.recruitment__openchat-name',text: openchat_name)
      expect(page).to have_css('.recruitment__description',text: description)
    end

    within before_edit do
      click_on 'Edit'
    end

    fill_in 'Description',with: "aa"
    fill_in 'Password',with: wrong_password 
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

    before_destroy = recruit(
      openchat_name:openchat_name,
      invite_url:invite_url,
      description:description,
      password:password)

    page.save_screenshot("EditRecruitment-#{DateTime.now}.png")
    within before_destroy do
      expect(page).to have_css('.recruitment__openchat-name',text: openchat_name)
      expect(page).to have_css('.recruitment__description',text: description)
    end

    within before_destroy do
      click_on 'Edit'
    end

    fill_in 'Password for deletion',with: password
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

    within before_edit do
      click_on 'Edit'
    end

    fill_in 'Description',with: "aa"
    fill_in 'Password',with: wrong_password 
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

    before_comment = recruit(
      openchat_name:openchat_name,
      invite_url:invite_url,
      description:description,
      password:password)

    page.save_screenshot("BeforeComment-#{DateTime.now}.png")

    after_comment = find_recruitment(openchat_name:openchat_name)

    comment_on(
      recruitment:before_comment,
      comment:comment,
      password:password)

    within(before_comment) do
      expect(page).to have_css('.recruitment__comment',text: comment) 
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

    before_comment = recruit(
      openchat_name:openchat_name,
      invite_url:invite_url,
      description:description,
      password:password)

    comment_on(
      recruitment:before_comment,
      comment:comment,
      password:password)

    page.save_screenshot("AfterComment-#{DateTime.now}.png")

    within before_comment do
      expect(page).to have_css('.recruitment__comment',text: comment) 
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

    before_comment = recruit(
      openchat_name:openchat_name,
      invite_url:invite_url,
      description:description,
      password:password)

    page.save_screenshot("BeforeComment-#{DateTime.now}.png")


    target_comment = comment_on(
      recruitment:before_comment,
      comment:comment,
      password:password)


    target_reply = reply_to(openchat_name:openchat_nane, target:target_comment, text:reply, password:password)

    expect(page).to have_css('.recruitment__comment .recruitment__comment--reply',text: reply)

  end
end
