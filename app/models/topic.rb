class Topic < ApplicationRecord
  validates :title, uniqueness: { scope: :project_id }, presence: true
  belongs_to :project
  has_many :messages, dependent: :destroy
end
