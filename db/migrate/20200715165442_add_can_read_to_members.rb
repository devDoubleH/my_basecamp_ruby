class AddCanReadToMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :members, :can_read, :boolean
  end
end
