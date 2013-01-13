class necro.AppBody
  constructor: (@panel)->
  init: ->
    @tabbar = @panel.attachTabbar()
    @tabbar.setImagePath('/assets/dhtmlx/imgs/')
    @tabbar.addTab("intro", "Introduction")
    @tabbar.setTabActive("intro")
    @tabbar.setContentHTML("intro", "Lorem ipsum dolor sit amet")

