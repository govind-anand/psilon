define ['./subview'], (Subview)->

  class ProjectList extends Subview
    constructor: -> super
    show: ->
      @parent.panel.setText 'Projects'
      @parent.panel.attachHTMLString "<div class='loader'></div>"
      $.ajax
        url: '/users/current/projects.html'
        success: (data)=>
          @parent.panel.attachHTMLString data
        error: =>
          @parent.panel.attachHTMLString "Failed to load content."
      this
