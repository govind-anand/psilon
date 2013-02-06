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
        @selected = []
        self = this
        @on 'click', '.pitem-wrapper', ->
          el = $(this)
          tel = el.find('.pitem')
          pitem = tel.text()
          if el.hasClass 'selected'
            self.selected = _.without self.selected, pitem
            el.removeClass 'selected'
          else
            self.selected.push pitem
            el.addClass 'selected'
          self.renderOpTbar()
        psi.subscribe "post:projects:update", =>
          @showProjects()

      renderOpTbar: ->
        if @selected.length == 0
          @opTbar?.hide()
          @body.css bottom: 0
        else if @selected.length > 0 
          unless @opTbar
            @opTbar = $$ ->
              _.extend this, toolbar, buttons
              @toolbar class: 'op-toolbar', =>
                @icoBtn
                  icon: 'trash'
                  title: 'Delete'
                @icoBtn
                  icon: 'download'
                  title: 'Download'
                @icoBtn
                  icon: 'add-user'
                  title: 'Share'
                @icoBtn
                  icon: 'pencil'
                  title: 'Rename'
            @body.css bottom: 25
            @opTbar.appendTo this
          @opTbar.show()

      afterAttach: ->
        psi.loadCSS 'tooltipster/css/tooltipster'
        psi.loadCSS 'tooltipster/css/themes/tooltipster-shadow'
        @icoTbar.find('a').tooltipster 
          theme: '.tooltipster-shadow'
          position: 'bottom'

      _renderList: (list)->
        $$ -> @ul class:'plist', => 
          for item in list
            @li class: 'pitem-wrapper', =>
              @div class: 'icon lfloat', =>
                @raw '&#10002;'
              @a class: 'icon rfloat project-opener', href: "#/project/#{item.id}", =>
                @raw '&#59226;'
              @a class: 'pitem', => @text item.name

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