class ChangePostsRestrictionDefault < ActiveRecord::Migration
  def change
    change_column_default :posts, :restriction, 1
  end
end
