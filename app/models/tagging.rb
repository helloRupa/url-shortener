class Tagging < ApplicationRecord
  validates :tag_id, :link_id, presence: true

  belongs_to :tag_topic,
    class_name: 'TagTopic',
    primary_key: :id,
    foreign_key: :tag_id

  belongs_to :link,
    class_name: 'ShortenedUrl',
    primary_key: :id,
    foreign_key: :link_id
end
