class AddIsAdminToMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :members, :is_admin, :boolean, default: false
  end
end
