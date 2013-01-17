define ['./subview'], (Subview)->

  class ProjectList extends Subview
    constructor: -> 
      super
    show: ->
      @parent.setTitle 'Projects'
      $.ajax
        url: '/users/current/projects.html'
        success: (data)=>
          @parent.body.html data
        error: =>
          @parent.body.html "Failed to load content."
      this
