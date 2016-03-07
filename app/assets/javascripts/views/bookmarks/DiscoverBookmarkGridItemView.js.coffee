class Mywebroom.Views.DiscoverBookmarkGridItemView extends Backbone.View
	#*******************
	#**** Tag  (no tag = default el "div")
	#*******************
	tagName:"li"
	#*******************
	#**** Templeate
	#*******************
	template:JST['bookmarks/DiscoverGridItemTemplate']
	events:
		'click .add_bookmark_icon_hover':'addBookmark'
	#*******************
    #**** Render
    #*******************
	render:->
		$(@el).html(@template(model:@model))
	
	#--------------------------
	# Add bookmark to server. Append "Added" to the el. 
	#--------------------------
	addBookmark:(event)-> 
		event.stopPropagation()
		#To determine position, we need the user id, and bookmarks collection.
		userId = @getUserId() 
		@getMyBookmarksCollection(userId)
		#Finally call api to add the bookmark.
		postBookmarkModel = new Mywebroom.Models.CreateUserBookmarkByUserIdBookmarkIdItemId({itemId:@model.get('item_id'), bookmarkId:@model.get('id'),userId:userId})
		if @myBookmarksCollection.length is 0
			lastBookmarkPosition = 1
		else
			lastBookmarkPosition = parseInt(_.last(@myBookmarksCollection.models).get('position'))
		postBookmarkModel.set 'position',lastBookmarkPosition+1		
		postBookmarkModel.save {},
			success: (model, response)->
				console.log('postBookmarkModel SUCCESS:')
				console.log(response)
			error: (model, response)->
		        console.log('postBookmarkModel FAIL:')
		        console.log(response)
       #Append Added Confirmation HTML 
       #TODO- make added dialog disappear after 5-10 seconds. (Keep checkmark)
		@$('.bookmark_grid_item').append("<div class='just_added'>
			<p>Added!</p>
			<img src='http://res.cloudinary.com/hpdnx5ayv/image/upload/v1378226370/bookmarks-corner-icon-check-confirmation.png'>
			</div>")
	#--------------------------
	# Retrieve the signed in user id. Called from addBookmark
	#--------------------------
	getUserId:->
		userSignInCollection = new Mywebroom.Collections.ShowSignedUserCollection()
		userSignInCollection.fetch async: false
		userSignInCollection.models[0].get('id')
	#--------------------------
	# Retrieve the MyBookmarks Collection. Called from addBookmark.  
	#--------------------------
	getMyBookmarksCollection:(userId)->
		@myBookmarksCollection = new Mywebroom.Collections.IndexUserBookmarksByUserIdAndItemIdCollection()
		@myBookmarksCollection.fetch
		  async:false
		  url:@myBookmarksCollection.url userId, @model.get('item_id')

