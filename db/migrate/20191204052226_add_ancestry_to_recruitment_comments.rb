class AddAncestryToRecruitmentComments < ActiveRecord::Migration[5.2]
  def change
    add_column :recruitment_comments, :ancestry, :string
    add_index :recruitment_comments, :ancestry
  end
end
