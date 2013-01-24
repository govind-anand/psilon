define [
    'space-pen'
  ],(
    View
  )->

    class ProjectCreator extends View

      @content: ->
        @form submit: 'submit', =>
          @table => 
            @tr outlet: 'pcreate-row-name', =>
              @td => @label "Name of project"
              @td => @input outlet: 'nameField'
            @tr outlet: 'pcreate-row-submit', =>
              @td => @raw('&nbsp;')
              @td => @input type:'submit', value:'Create'

      _getData: ->
        name: @nameField.attr('value')

      submit: ->
        psi.registry.projects.add @_getData()
        return false

      initialize: ->
        psi.subscribe "post:project:create", ->
          window.location.hash = '#/'
