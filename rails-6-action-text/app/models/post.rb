class Post < ApplicationRecord
  has_rich_text :content

  validates :title, length: { maximum: 34 }, presence: true

  validate :validate_content_length
  validate :validate_content_attachment_byte_size

  MAX_CONTENT_LENGTH = 500
  ONE_KILOBYTE = 1024
  MEGA_BYTES = 3
  MAX_CONTENT_ATTACHEMENT_BYTE_SIZE = MEGA_BYTES * (1_000 * ONE_KILOBYTE)

  private

  def validate_content_attachment_byte_size
    content.body.attachables.grep(ActiveStorage::Blob).each do |attachable|
      if attachable.byte_size > MAX_CONTENT_ATTACHEMENT_BYTE_SIZE
        errors.add(
          :base,
          :content_attachment_byte_size_is_too_big,
          max_content_attachment_mega_byte_size: MEGA_BYTES,
        )
      end
    end
  end

  def validate_content_length
    if content.to_plain_text.length>  MAX_CONTENT_LENGTH
      errors.add(:content, :too_long, max_content_length: MAX_CONTENT_LENGTH, length: content.to_plain_text.length)
    end
  end
end
