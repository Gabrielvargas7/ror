class Mywebroom.Views.AProfileGridItemView2 extends Marionette.ItemView
  tagName:'div'
  className:'gridItemWrap'
  template:JST['profile/ProfileGridItemTemplate2']
  events: 
    'mouseenter .gridItem':'showSocialBarView' 
    'mouseleave .gridItem':'closeSocialBarView'
    'click .gridItem':'getGridItemModel'
  onRender:->
    #Depending on FLAG_PROFILE, hover will cause different view here. 
    @socialBarView = new Mywebroom.Views.SocialBarView(model:@model)
    $(@el).children(".gridItem").children(".gridItemPicture").append(@socialBarView.el)
    @socialBarView.render()
    @socialBarView.hide()
  showSocialBarView:(event)->
    @socialBarView.show()
   closeSocialBarView:->
    @socialBarView.hide()
  getGridItemModel: (event) ->
    this.trigger('gridItemLargeView',@model)
    event.stopPropagation()
    dataID = event.currentTarget.dataset.id
    console.log("You clicked a grid Item in ProfileGridItemView " +this.model.get('id'))
    #gridItem is either Activity Item or Photo. Determine which. 
      
    


  