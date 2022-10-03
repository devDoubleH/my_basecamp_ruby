class AddProjectIdToMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :members, :project_id, :integer
  end
end
