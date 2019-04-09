class RenameTopicsColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :tag_topics, :topics, :topic
  end
end
