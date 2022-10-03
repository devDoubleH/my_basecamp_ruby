class AddCanWriteToMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :members, :can_write, :boolean
  end
end
