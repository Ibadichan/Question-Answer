# frozen_string_literal: true

module PublicIndexAndShow
  extend ActiveSupport::Concern

  included do
    skip_before_action :authenticate_user!, only: %i[index show]
    skip_before_action :ensure_sign_up_complete, only: %i[show index]
  end
end
