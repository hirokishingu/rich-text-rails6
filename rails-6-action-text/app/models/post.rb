class Post < ApplicationRecord
  has_rich_text :content

  validates :title, length: { maximum: 34 }, presence: true

  validate :validate_content_length

  MAX_CONTENT_LENGTH = 50

  def validate_content_length
    if content.to_plain_text.length>  MAX_CONTENT_LENGTH
      errors.add(:content, :too_long, max_content_length: MAX_CONTENT_LENGTH, length: content.to_plain_text.length)
    end
  end
end
