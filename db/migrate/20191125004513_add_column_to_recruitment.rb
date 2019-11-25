class AddColumnToRecruitment < ActiveRecord::Migration[5.2]
  def change
    add_column :recruitments, :description, :text
    add_column :recruitments, :room_url, :string
  end
end
