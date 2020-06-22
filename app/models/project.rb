class Project < ApplicationRecord
  has_many :todos, dependent: :destroy, inverse_of: :project
  accepts_nested_attributes_for :todos

  validates :title, presence: true, length: { maximum: 156 }, uniqueness: true
end
