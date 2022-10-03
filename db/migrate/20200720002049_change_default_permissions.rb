class ChangeDefaultPermissions < ActiveRecord::Migration[6.0]
  def change
    change_column_default :members, :can_read, false
    change_column_default :members, :can_update, false
    change_column_default :members, :can_write, false
    change_column_default :members, :can_delete, false
  end
end
