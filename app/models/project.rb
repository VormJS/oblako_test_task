class Project < ApplicationRecord
  has_many :todos, dependent: :destroy

  validates :title, presence: true, length: { maximum: 156 }, uniqueness: true
end
