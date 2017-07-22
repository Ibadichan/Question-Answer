# frozen_string_literal: true

module PublicIndexAndShow
  extend ActiveSupport::Concern

  included do
    skip_before_action :authenticate_user!, only: %i[index show]
  end
end
