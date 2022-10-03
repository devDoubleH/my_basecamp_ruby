class AddCanDeleteToMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :members, :can_delete, :boolean
  end
end
