class Mywebroom.Collections.IndexBookmarksCategoriesByItemId extends Backbone.Collection
	url:(itemId)->
		"/bookmarks_categories/json/index_bookmarks_categories_by_item_id/"+itemId+".json"