# frozen_string_literal: true

class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
      t.text :body
      t.belongs_to :question, index: true
    end
  end
end
