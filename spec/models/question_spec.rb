# frozen_string_literal: true

require 'rails_helper'
require_relative 'concerns/attachable'
require_relative 'concerns/votable'

RSpec.describe Question, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:answers).dependent(:destroy) }
  it_behaves_like 'attachable'
  it_behaves_like 'votable'

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end
