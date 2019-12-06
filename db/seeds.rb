# coding: utf-8


recruitment_001 = 
  Recruitment.create :room_name => '集合',
    :description => '説明',
    :room_url => 'https://line.me/ti/g2/EUspWaMfsZ0PnuS9dkxI2g',
    :password_digest => BCrypt::Password.create('abcde')

recruitment_001.recruitment_comments.create :text => "Hello",
  :password_digest => BCrypt::Password.create('abcde') 



                   
