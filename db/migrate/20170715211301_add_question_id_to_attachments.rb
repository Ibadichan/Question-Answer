# frozen_string_literal: true

class AddQuestionIdToAttachments < ActiveRecord::Migration[5.1]
  def change
    add_column :attachments, :question_id, :integer
  end
end
