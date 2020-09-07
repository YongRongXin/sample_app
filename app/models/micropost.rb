class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "must be a valid image format" },
                   size:          { less_than: 5.megabytes,
                                    message: "should be less than 5MB" }
  scope :recent_posts, -> {order created_at: :desc}

  def display_image
    image.variant resize_to_limit: [Settings.image_size.width, Settings.image_size.height]
  end
end
