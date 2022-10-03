class RemoveUserFromMessages < ActiveRecord::Migration[6.0]
  def change
    remove_reference :messages, :user, null: false, foreign_key: true
  end
end
