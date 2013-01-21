define [
    'space-pen'
  ],(
    View
  )->

    class ProjectCreator extends View
      submit: ->
        $.ajax
          type: 'POST',
          data:
            project:
              name: @name_field.attr('value')
          url: '/projects'
          success: (data)->
            if data.success
              psi.ui.notifier.success "Project creation successful"
              psi.publish 'stask:project-creation:successful'
              window.location.hash = '#/'
            else
              psi.ui.notifier.error "Creation failed"
              psi.publish 'stask:project-creation:failed'
          error: ->
            psi.ui.notifier.error "Project creation failed"
        return false
      @content: ->
        @form submit: 'submit', =>
          @table => 
            @tr outlet: 'pcreate-row-name', =>
              @td => @label "Name of project"
              @td => @input outlet: 'name_field'
            @tr outlet: 'pcreate-row-submit', =>
              @td => @raw('&nbsp;')
              @td => @input type:'submit', value:'Create'