class CreateRecruitmentComments < ActiveRecord::Migration[5.2]
  def change
    create_table :recruitment_comments do |t|
      t.string :text
      t.string :password_digest
      t.references :recruitment, foreign_key: true

      t.timestamps
    end
  end
end
