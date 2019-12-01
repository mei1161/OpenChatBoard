class AddPasswordDigestToRecruitments < ActiveRecord::Migration[5.2]
  def change
    add_column :recruitments, :password_digest, :string
  end
end
