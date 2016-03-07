###
This view represents a clickable design in the room
###
class Mywebroom.Views.RoomUserItemsDesignsView  extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************


  #*******************
  #**** Templeate
  #*******************
  template: JST['rooms/RoomUserItemsDesignsTemplate']


  #*******************
  #**** Events
  #*******************
  events:
    'click img.room_user_item_design'     : 'clickItem'
    'mouseenter img.room_user_item_design': 'hoverItem'
    'mouseleave img.room_user_item_design': 'hoverOffItem'

  #*******************
  #**** Initialize
  #*******************
  initialize: ->

    @design = @options.design
    #*******************
    #**** Render
    #*******************
  render: ->

    $(@el).append(@template(user_item_design: @design))
    this.setHoverOffOnImages()

    y = @design.y.toString() + 'px'
    x = @design.x.toString() + 'px'
    z = @design.z.toString()
    
    width = @design.width.toString() + 'px'
    id_room_item_designs_container = ".room_item_designs_container_" + @design.item_id.toString()

    $(id_room_item_designs_container).css({
      'position': 'absolute',
      'width'   : width,
      'left'    : x,
      'top'     : y,
      'z-index' : z
    })
     

    this

  #*******************
  #**** Funtions
  #*******************

  #--------------------------
  # set hover on off images by jquery
  #--------------------------
  setHoverOffOnImages: ->

    if @design.clickable is "yes"
      itemId         = @design.item_id
      imageNameHover = @design.image_name_hover.url
      imageName      = @design.image_name.url
      
      $el = $('[data-room_item_id=' + itemId + ']')
      
      # Turn on conditional hovering unless the designs are hidden
      unless $el.data("roomHide") is "yes"
        $el.hover (->  $(this).attr("src", imageNameHover)), -> $(this).attr("src", imageName)





  #--------------------------
  # do something on click
  #--------------------------
  clickItem: (event) ->
    event.preventDefault()

    
    @hideAndShowBookmarks(@design.item_id)
    @displayBookmark()

    if @design.clickable is "yes"
      bookmarksView = new Mywebroom.Views.BookmarksView({items_name:@design.items_name,user_item_design: @design.item_id, user: Mywebroom.State.get("roomUser").get("id") })
      
      self = this
      $('#room_bookmark_item_id_container_' + @design.item_id).append(bookmarksView.el)
      bookmarksView.render()





  #--------------------------
  # change hover image on mouse over
  #--------------------------
  hoverItem: (event) ->
    event.preventDefault()



  #--------------------------
  # change normal image on hover
  #--------------------------
  hoverOffItem: (event) ->
    event.preventDefault()


  #--------------------------
  # hide bookmarks when is not this item
  #--------------------------
  hideAndShowBookmarks:(bookmark_item_id) ->
    designs = Mywebroom.State.get("roomDesigns")
    

    length = designs.length
    i = 0
    while i < length
      if bookmark_item_id is designs[i].item_id
        $('#room_bookmark_item_id_container_' + designs[i].item_id).show()
      else
        $('#room_bookmark_item_id_container_' + designs[i].item_id).hide()
      i += 1

  #--------------------------
  # hide store and profile pages
  #--------------------------
  displayBookmark: ->
    $('#xroom_store_menu_save_cancel_remove').hide()
    $('#xroom_storepage').hide()
    $('#xroom_profile').hide()
    $('#xroom_bookmarks').show()

