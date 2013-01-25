define ->
  [{
    id: 'file'
    label: 'File'
    children: [{
        id: 'save'
        label: 'Save'
        evt: 'pre:editor:save'
      },{
        id: 'save_as'
        label: 'Save As'
        evt: 'pre:editor:save_as'
      },{
        id: 'close'
        label: 'Close'
        evt: 'pre:editor:close'
      }]
  },{
    id: 'edit'
    label: 'Edit'
    children: [{
        id: 'undo'
        label: 'Undo'
      },{
        id: 'redo'
        label: 'Redo'
      },{
        id: 'preferences'
        label: 'Preferences'
      }]
  },{
    id: 'project'
    label: 'Project'
    children: [{
        id: 'settings'
        label: 'Settings'
      },{
        id: 'share'
        label: 'Share'
      }]
  },{
    id: 'favourites'
    label: 'Favourites'
    children: [{
        id: 'files'
        label: 'Files'
      },{
        id: 'folders'
        label: 'Folders'
      },{
        id: 'recently_visited'
        label: 'Recently Visited'
      }]
  },{
    id: 'tools'
    label: 'Tools'
    children: [{
        id: 'extensions'
        label: 'Extensions'
      }]
  },{
    id: 'help'
    label: 'Help'
    children: [{
      id: 'video_tutorials'
      label: 'Video tutorials'
    },{
      id: 'manual'
      label: 'Manual'
    },{
      id: 'tutorials'
      label: 'Tutorials'
    }]
  }]