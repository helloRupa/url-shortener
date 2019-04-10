class ShortenedUrl < ApplicationRecord
  validates :short_url, :long_url, :user_id, presence: true
  validates :short_url, uniqueness: true
  validate :no_spamming, :nonpremium_max, on: :create

  before_validation do
    self.short_url = ShortenedUrl.random_code if self.short_url.nil?
  end

  belongs_to :submitter,
    class_name: 'User',
    primary_key: :id,
    foreign_key: :user_id

  has_many :clicks,
    class_name: 'Visit',
    primary_key: :short_url,
    foreign_key: :short_url,
    dependent: :destroy

  has_many :visitors,
    Proc.new { distinct },
    through: :clicks,
    source: :user_visits

  has_many :taggings,
    class_name: 'Tagging',
    primary_key: :id,
    foreign_key: :link_id,
    dependent: :destroy

  has_many :tag_topics,
    through: :taggings,
    source: :tag_topic

  def self.random_code
    url = SecureRandom::urlsafe_base64
    url = SecureRandom::urlsafe_base64 while ShortenedUrl.exists?(short_url: url)
    url
  end

  def self.generate_shortened_url(user_obj, long_url)
    ShortenedUrl.create!({long_url: long_url, user_id: user_obj.id})
  end

  def num_clicks
    clicks.count
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    clicks.select(:user_id).distinct.where("created_at > ?", 10.minutes.ago).count
  end

  def no_spamming
    spamming = ShortenedUrl.where("user_id = ? AND created_at > ?", self.user_id, 1.minutes.ago).count >= 5
    errors.add(:user_id, message: 'Too many posts in one minute') if spamming
  end

  def nonpremium_max
    if !self.submitter.premium && self.submitter.submitted_urls.count > 4
      errors.add(:user_id, message: 'Must be Premium user to submit more than 5 links')
    end
  end

  def self.prune(n)
    # Links created more than n minutes ago and never visited
    # Links not visited in the last n minutes
    ShortenedUrl
      .where
      .not(id: (ShortenedUrl
        .left_outer_joins(:clicks)
        .joins(:submitter)
        .distinct
        .where('shortened_urls.created_at > ? OR visits.created_at > ? OR users.premium = true', n.minutes.ago, n.minutes.ago))
      ).destroy_all
  end
end
