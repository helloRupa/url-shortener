class Visit < ApplicationRecord
  validates :user_id, :short_url, presence: true

  has_many :user_visits,
    class_name: 'User',
    primary_key: :user_id,
    foreign_key: :id

  belongs_to :url,
    class_name: 'ShortenedUrl',
    primary_key: :short_url,
    foreign_key: :short_url

  def self.record_visit!(user, shortened_url)
    Visit.create!({user_id: user.id, short_url: shortened_url.short_url})
  end
end