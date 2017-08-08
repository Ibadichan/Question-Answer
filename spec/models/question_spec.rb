# frozen_string_literal: true

require 'rails_helper'
require_all 'spec/models/concerns'

RSpec.describe Question, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:answers).dependent(:destroy) }

  it_behaves_like 'attachable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end
