class Topic < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  extend ApiHandling
  expose_api :id, :event_id, :user_id, :name, :description

  validates :user, :name, :description, :label, presence: true
  validates :name, uniqueness: true

  belongs_to :user
  belongs_to :event

  has_many :likes, dependent: :destroy

  scope :ordered, -> { order('created_at DESC') }
  scope :undone,  -> { where('event_id IS NULL') }
  scope :done,    -> { where('event_id IS NOT NULL') }

  default_scope -> { where(label: Whitelabel[:label_id]) }

  def already_liked?(user)
    likes.detect{ |like| like.user == user }
  end
end
