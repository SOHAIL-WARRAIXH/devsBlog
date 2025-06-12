class AddCaptionToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :caption, :text
  end
end
