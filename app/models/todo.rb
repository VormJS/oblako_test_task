class Todo < ApplicationRecord
  belongs_to :project, inverse_of: :todos
  validates_presence_of :project

  validates :text, presence: true

  default_scope -> { order(created_at: :asc) }
end
