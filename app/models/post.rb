class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  has_many_attached :images

  validates :caption, length: { maximum: 5000 }

  scope :latest, -> { order(created_at: :desc) }
  scope :with_user, -> { includes(:user) }
  scope :with_comments, -> { includes(comments: :user) }
  scope :with_likes, -> { includes(:likes) }

  def liked_by?(user)
    likes.exists?(user: user)
  end

  def like_count
    likes.count
  end

  def comment_count
    comments.count
  end
end
