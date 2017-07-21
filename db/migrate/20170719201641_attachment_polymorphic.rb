# frozen_string_literal: true

class AttachmentPolymorphic < ActiveRecord::Migration[5.1]
  def change
    add_column :attachments, :attachable_id, :integer, foreign_key: true
    add_column :attachments, :attachable_type, :string
    add_index :attachments, %i[attachable_id attachable_type]
  end
end