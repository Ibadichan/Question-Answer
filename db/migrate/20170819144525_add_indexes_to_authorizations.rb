# frozen_string_literal: true

class AddIndexesToAuthorizations < ActiveRecord::Migration[5.1]
  def change
    add_index :authorizations, %i[provider uid]
  end
end
