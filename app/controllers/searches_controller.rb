# frozen_string_literal: true

class SearchesController < ApplicationController
  include PublicIndexAndShow
  skip_authorization_check
  before_action :set_params

  def show
    respond_with @found_objects = Search.find_object(@query, @category) if @query.present? && @category
  end

  private

  def set_params
    @query = params[:query]
    @category = params[:category]
  end
end
