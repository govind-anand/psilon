define [
    'space-pen'
    'underscore'
    'config/ico_map'
    'views/widgets/toolbar'
    'views/widgets/buttons'
    'tooltipster/js/jquery.tooltipster'
  ],(
    View,
    _,
    icoMap,
    toolbar, buttons
  )->

    class ProjectList extends View

      _.extend this, toolbar, buttons

      @content: ->
        @div id: 'project-list', =>
          @toolbar pseudo: true, outlet: 'icoTbar', =>
            @icoBtn 
              icon: 'numbered-list'
              title: 'Your projects'
              click: 'showProjects'
              outlet: 'pListIcoTab'
            @icoBtn
              icon: 'squared-plus'
              title: 'New project'
              click: 'createProject'
              outlet: 'pCreatorIcoTab'
            @icoBtn
              icon: 'upload'
              title: 'Upload new project'
              click: 'uploadProject'
              outlet: 'pUploaderIcoTab'
            @icoBtn 
              icon: 'github'
              title: 'Import from github'
              isSocial: true
              outlet: 'pGithubIcoTab'
            @icoBtn
              icon: 'dropbox'
              title: 'Import from Dropbox'
              isSocial: true
              outlet: 'pDropboxIcoTab'
            @icoBtn
              icon: 'download'
              title: 'Download'
              outlet: 'pDownloadIcoTab'
          @div class: 'body', outlet: 'body'

      initialize: ->
        @title = "Projects"
        psi.subscribe "post:projects:update", =>
          @showProjects()

      afterAttach: ->
        psi.loadCSS 'tooltipster/css/tooltipster'
        psi.loadCSS 'tooltipster/css/themes/tooltipster-shadow'
        @icoTbar.find('a').tooltipster 
          theme: '.tooltipster-shadow'
          position: 'bottom'

      _renderList: (list)->
        $$ -> @ul => 
          for item in list
            @li =>
              @a href: "#/project/#{item.id}", =>
                @div class: 'icon lfloat', =>
                  @raw '&#10002;'
                @text item.name

      mask: ->
        @body.html psi.frags.loader

      setSelected: (icoTab)->
        @icoTbar
          .find('a')
          .removeClass('selected')
        icoTab.addClass 'selected'

      showProjects: ->
        @body.html ''
        projects = psi.registry.projects.getAll()
        @setSelected @pListIcoTab
        if projects.length > 0
          @body.html @_renderList(projects)
        else
          @body.html $$ -> @div class:'vacancy-msg', "No projects found"

      createProject: ->
        @mask()
        @setSelected @pCreatorIcoTab
        require ['views/project_creator'], (ProjectCreator)=>
          @body.html('').append(new ProjectCreator)

      uploadProject: ->
        @mask()
        @setSelected @pUploaderIcoTab
        require ['views/project_uploader'], (ProjectUploader)=>
          @body.html('').append(new ProjectUploader)