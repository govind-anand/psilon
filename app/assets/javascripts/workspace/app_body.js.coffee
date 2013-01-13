class necro.AppBody
  constructor: (@panel)->
  init: ->
    @tabbar = @panel.attachTabbar()
    @tabbar.setImagePath(necro.imagePath)
    @tabbar.addTab("intro", "Introduction")
    @tabbar.setTabActive("intro")
    @tabbar.setContentHTML("intro", "Lorem ipsum dolor sit amet")

