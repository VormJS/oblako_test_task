require 'rails_helper'

RSpec.describe Todo, type: :model do
  it { should validate_presence_of(:text) }

  it { should belong_to(:project) }
end
