# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  message    :text
#  visible    :boolean          default(FALSE)
#  article_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class Comment < ApplicationRecord
  extend FriendlyId

  belongs_to :article
  belongs_to :user

  friendly_id :uuid, use: [:slugged,:finders]

  before_create :generate_uuid
  after_create :manually_update_slug
  validates :message, presence: true

  def generate_uuid
    self.uuid = "#{self.model_name.name}-" + SecureRandom.uuid
    p "Comment UUID- #{self.uuid} has been created"
  end

  def manually_update_slug
    self.update_column(:slug,self.uuid)
  end
end
