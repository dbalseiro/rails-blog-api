# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  it 'is valid with valid attributes' do
    comment = build :comment
    expect(comment).to be_valid
  end

  it 'is invalid without a human validation' do
    comment = build :unaccepted_comment
    expect(comment).not_to be_valid
  end

  it 'is invalid without an article' do
    comment = build :comment_without_article
    expect(comment).not_to be_valid
  end
end
