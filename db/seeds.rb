# coding: utf-8

password_digest = BCrypt::Password.create("WUXX996Tmv4S")

recruitment_001 = 
  Recruitment.create :room_name => 'どうぶつの森',
    :description => 'どうぶつの森通信したいひとあつまれー！！',
    :room_url => 'https://line.me/ti/g2/EUspWaMfsZ0PnuS9dkxI2g',
    :password_digest => password_digest 

recruitment_001_comment_001 =
  recruitment_001.recruitment_comments.create :text => "質問です。このトークルームに入る条件はありますか？",
    :password_digest => password_digest

recruitment_001_comment_001_reply_001 =
  recruitment_001_comment_001.children.create :text => "どうぶつの森をやっている方なら、誰でも歓迎です。ただし、参加された際には自己紹介をお願いします。",
    :password_digest => password_digest

recruitment_002 = 
  Recruitment.create :room_name => 'プログラミング学ぼう！',
    :description => 'プログラミング一緒に勉強したい人一緒に勉強しましょう！',
    :room_url => 'https://line.me/ti/g2/u3vxhSTwMzWMd8-lNBuaFA',
    :password_digest => password_digest

recruitment_002_comment_001 =
  recruitment_002.recruitment_comments.create :text => "プログラミングやったことがない人でも参加できますか？",
    :password_digest => password_digest

recruitment_002_comment_001_reply_001 =
  recruitment_002_comment_001.children.create :text => "はい。未経験者でも是非ご参加ください。先輩からプログラミングを教わるとよいでしょう。",
    :password_digest => password_digest
                   
