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

  def find_reply(comment:)
    comment_text = find('.recruitment__comment--reply', text: comment)
    return comment_text.find(:xpath,"..")
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
#        return find_reply comment: text
    end
  end

  scenario 'Show recruitment lists' do
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
    
    within result do
      click_on 'Join'
    end

    expect(page).to have_title "LINE OPENCHAT"
  end

  scenario 'Edit-recruitment with correct_password' do
    openchat_name = "testchat2"
    invite_url = "https://line.me/ti/g2/EUz"
    description = "aaaa"
    password = "123"

    recruitment_before_edit = 
      recruit openchat_name: openchat_name,
        invite_url: invite_url,
        description: description,
        password: password

    within recruitment_before_edit do
      click_on 'Edit'
    end

    fill_in 'Description', with: "aa"
    fill_in 'Password', with: password
    click_on 'Edit'

    recruitment_after_edit = 
      find_recruitment openchat_name: openchat_name

    within recruitment_after_edit do
      expect(page).to have_css('.recruitment__openchat-name', text: openchat_name)
      expect(page).to have_css('.recruitment__description', text: "aa")
    end
  end

  scenario 'Edit with Wrong Password' do
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

    within recruitment_before_edit do
      click_on 'Edit'
    end

    fill_in 'Description',with: "aa"
    fill_in 'Password', with: wrong_password 
    click_on 'Edit'

    expect(page).to have_text("Password invalid")
  end

  scenario 'Destroy a recruitment' do
    openchat_name = "testchat2"
    invite_url = "https://line.me/ti/g2/EUz"
    description = "aaaa"
    password = "123"

    recruitment_before_destroy = 
      recruit openchat_name: openchat_name,
        invite_url: invite_url,
        description: description,
        password: password

    within recruitment_before_destroy do
      click_on 'Edit'
    end

    fill_in 'Password for deletion', with: password
    click_on 'Delete'

    expect(page).to have_no_css('.recruitment__openchat-name')
  end

  scenario 'Destroy with wrong password' do
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

    within recruitment_before_edit do
      click_on 'Edit'
    end

    fill_in 'Description', with: "aa"
    fill_in 'Password', with: wrong_password 
    click_on 'Delete'

    expect(page).to have_text("Password invalid")
  end

  scenario 'Recruitment_Comment test' do
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

      within recruitment_before_comment do
        comment_on comment: comment, password: password
        expect(page).to have_css('.recruitment__comment', text: comment) 
      end
  end

  scenario 'Delete related comments by deleting recruitment' do
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

    within recruitment_before_comment do
      comment_on comment: comment, password: password
      click_on 'Edit'
    end

    fill_in 'Password for deletion', with: password
    click_on 'Delete'

    expect(page).to have_no_css('.recruitment__comment')
  end

  scenario 'Reply to comment' do
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

    within recruitment_before_comment do
      target_comment = comment_on comment: comment, password: password
      within target_comment do
        reply_to target: target_comment,
          text: reply,
          password: password
        page.save_screenshot("AAA#{DateTime.now}.png")
    end
      # target_reply = 
      #   reply_to target: target_comment, 
      #     text: reply, 
      #     password: password

      # within target_reply do
      #   expect(page).to have_css('.recruitment__comment', text: reply)
      # end
    end
  end

  scenario 'Reply to reply' do
    openchat_name = "test"
    invite_url = "https://line.me/ti/g2/EUz"
    description = "aaaa"
    password = "123"
    comment = "[level 1] this is a comment"
    reply_level2 = "[level 2] this is a reply to comment"
    reply_level3 = "[level 3] this is a reply to reply"

    recruitment_before_comment =
      recruit openchat_name: openchat_name,
        invite_url: invite_url,
        description: description,
        password: password

    within recruitment_before_comment do
      target_comment = comment_on comment: comment, password: password
      reply_to  target: target_comment,
        text: reply_level2,
        password: password
      target_reply = find_reply comment: reply_level2

      reply_to target: target_reply,
        text: reply_level3,
        password: password

#      target_reply = 
#        reply_to target: target_comment, 
#          text: reply_level2,
#          password: password

    #  within target_reply do
    #    reply_to target: target_reply,
    #      text: reply_level3,
    #      password: password
      end
      page.save_screenshot("BBB#{DateTime.now}.png")
      expect(page).to have_css('.recruitment__comment .recruitment__comment--reply', text: reply_level3)
#    end
  end
  scenario 'Delete Comment with correct password' do
    openchat_name = "test"
    invite_url = "https://line.me/ti/g2/EUz"
    description = "aaaa"
    password = "123"
    comment = "[level 1] this is a comment"
    reply_level2 = "[level 2] this is a reply to comment"
    reply_level3 = "[level 3] this is a reply to reply"

    recruitment_before_comment =
      recruit openchat_name: openchat_name,
      invite_url: invite_url,
      description: description,
      password: password

    within recruitment_before_comment do
      target_comment = comment_on comment: comment, password: password
      reply_to  target: target_comment,
        text: reply_level2,
        password: password
      target_reply = find_reply comment: reply_level2

      within target_reply do
        click_on 'Delete'
        fill_in 'Delete Password',with: password
        click_button "Delete"
      end
      #      target_reply = 
      #        reply_to target: target_comment, 
      #          text: reply_level2,
      #          password: password

      #  within target_reply do
      #    reply_to target: target_reply,
      #      text: reply_level3,
      #      password: password
    end
    page.save_screenshot("CCC#{DateTime.now}.png")
    expect(page).to have_no_css('.recruitment__comment .recruitment__comment--reply')
    #    end
  end
end
