class LastEditTask < ActiveRecord::Migration[6.0]
  def change
    change_column_default :subtasks, :completed, false
    add_column :tasks, :last_edit, :integer
  end
end
