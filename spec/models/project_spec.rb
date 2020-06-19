require 'rails_helper'

RSpec.describe Project, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:title).ignoring_case_sensitivity }
  it { should validate_length_of(:title).is_at_most(156) }

  it { should have_many(:todos).dependent(:destroy) }
end
