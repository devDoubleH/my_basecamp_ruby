class Task < ApplicationRecord
  attr_accessor :last_edit_email, :last_edit_name
  belongs_to :project

  validates :title, presence: true
  has_many :subtasks, dependent: :destroy
end
