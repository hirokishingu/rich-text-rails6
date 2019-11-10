class Post < ApplicationRecord
  has_rich_text :content

  validates :title, length: { maximum: 34 }, presence: true
end
