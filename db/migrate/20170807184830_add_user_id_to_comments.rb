# frozen_string_literal: true

class AddUserIdToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :user_id, :integer, foreign_key: true
  end
end
