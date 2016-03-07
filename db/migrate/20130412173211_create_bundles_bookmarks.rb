class CreateBundlesBookmarks < ActiveRecord::Migration
  def change
    create_table :bundles_bookmarks do |t|
      t.integer :item_id
      t.integer :bookmark_id

      t.timestamps
    end
  end
end
