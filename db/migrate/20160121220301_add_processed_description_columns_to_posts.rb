class AddProcessedDescriptionColumnsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :description_markdown, :text
    add_column :posts, :description_stripdown, :string
  end
end
