class RemoveTitleAndContentFromPosts < ActiveRecord::Migration[8.0]
  def change
    remove_column :posts, :title, :string
    remove_column :posts, :content, :text
  end
end
