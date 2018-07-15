# frozen_string_literal: true

class Article < ApplicationRecord
  ATTRIBUTE_WHITELIST = [ :title, :text, :city, :state, :zipcode ]

  has_many :comments, dependent: :destroy, inverse_of: :article
  validates :title, presence: true, length: { minimum: 5 }
  geocoded_by :full_address
  after_validation :geocode

  scope :by_title, ->(title) { where('title like ?', "%#{title}%") if title.present? }
  scope :by_text, ->(text) { where('text like ?', "%#{text}%") if text.present? }
  scope :by_location, ->(location) { near(location, 20) if location.present? }
  scope :by_description, ->(description) { by_text(description).or by_title(description) }

  def full_address
    [city, state, zipcode].join(', ')
  end

  def self.search(query, location)
    Article.by_description(query).by_location(location)
  end
end
