define ['./subview'], (Subview)->

  class ProjectCreator extends Subview
    constructor: -> super
    show: ->
      @parent.panel.setText 'Create New Project'
      @form = form = @parent.panel.attachForm()
      formData = [
        type: 'fieldset'
        name: 'data'
        label: 'New Project'
        inputWidth: 'auto'
        list: [
          {
            type: 'input',
            name: 'project[name]',
            label: 'Name of project',
            validate: 'NotEmpty',
            position: 'label-top'
          },
          {
            type: 'checkbox',
            name: 'project[is_public]',
            label: 'Make public',
            position: 'label-right'
          },
          { type: 'button', name: 'create', value: 'Create'},
          { type: 'button', name: 'cancel', value: 'Cancel'}
        ]
      ]
      form.loadStruct formData, 'json'
      form.attachEvent 'onButtonClick', (name)->
        if name == 'create'
          if form.validate()
            necro.publish "user-action:project-create", form.getFormData()
        else if name == 'cancel'
          necro.publish "user-action:project-new-cancel"
      this
