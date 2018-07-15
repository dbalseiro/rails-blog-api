# frozen_string_literal: true

class Comment < ApplicationRecord
  ATTRIBUTE_WHITELIST = [:commenter, :body, :human]

  belongs_to :article, inverse_of: :comments
  validates_acceptance_of :human, allow_nil: false
end
