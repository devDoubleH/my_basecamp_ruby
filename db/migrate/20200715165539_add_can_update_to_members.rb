class AddCanUpdateToMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :members, :can_update, :boolean
  end
end
