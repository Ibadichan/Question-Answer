# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :email, :name, :id, :created_at, :updated_at, :admin
end
