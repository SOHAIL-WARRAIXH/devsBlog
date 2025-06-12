class CreatePostImages < ActiveRecord::Migration[8.0]
  def change
    create_table :post_images do |t|
      t.text :caption
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
