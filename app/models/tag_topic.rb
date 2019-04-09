class TagTopic < ApplicationRecord
  validates :topic, presence: true, uniqueness: true

  has_many :taggings,
    class_name: 'Tagging',
    primary_key: :id,
    foreign_key: :tag_id

  def popular_links
    links = self.taggings.map { |tagging| [tagging.link.long_url, tagging.link.num_clicks] }
    links.sort_by { |link| link[1] }.reverse[0..4]
  end
end
