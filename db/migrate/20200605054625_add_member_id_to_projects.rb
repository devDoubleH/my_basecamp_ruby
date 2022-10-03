class AddMemberIdToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :member_id, :integer
  end
end
