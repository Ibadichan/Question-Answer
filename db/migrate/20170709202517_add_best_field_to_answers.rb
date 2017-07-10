# frozen_string_literal: true

class AddBestFieldToAnswers < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :best, :boolean, default: false
  end
end
