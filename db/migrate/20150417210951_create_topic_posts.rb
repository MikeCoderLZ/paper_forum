class CreateTopicPosts < ActiveRecord::Migration
  def change
    create_table :topic_posts do |t|
      t.text :content
      t.references :user, index: true, foreign_key: true
      t.references :board, index: true, foreign_key: true
      t.references :root_post, index: true, foreign_key: true
      t.boolean :is_topic_post

      t.timestamps null: false
    end
  end
end
