class CreateTagTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :tag_topics do |t|
      t.string :topics, null: false, unqiue: true
      t.timestamps
    end
  end
end
