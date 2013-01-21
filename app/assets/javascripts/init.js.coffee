require.config
  baseUrl: '/assets'
  paths:
    'toastmessage': 'toastmessage/javascript/jquery.toastmessage'
  shim:
    'space-pen':
      exports: 'View'
      deps: ['jquery']
    'amplify':
      deps: ['jquery']
      exports: 'amplify'
    'toastmessage':
      deps: ['jquery']
    'jquery-ui':
      deps: ['jquery']
    'jstree/jquery.jstree':
      deps: ['jquery']

require ['psi', 'sugar'], -> 
  $ -> psi.init(true)