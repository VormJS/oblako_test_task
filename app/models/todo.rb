class Todo < ApplicationRecord
  belongs_to :project
  validates :text, presence: true

  default_scope -> { order(created_at: :asc) }
end
