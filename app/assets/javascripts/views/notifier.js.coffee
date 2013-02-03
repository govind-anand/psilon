define ['space-pen','toastmessage'], ->
  class Notifier
    _notifyNative: (type, msg)->
      img = "/assets/toastmessage/resources/images/#{type}.png"
      window.webkitNotifications.createNotification(img, type, msg).show()
    _hasNativeNotification: ->
      typeof window.webkitNotifications isnt 'undefined'
    _hasNativeEnabled: ->
      !! (window.webkitNotifications?.checkPermission?() == 0)
    init : ->
      if @_hasNativeNotification()
        unless @_hasNativeEnabled()
          $('body').on 'click', fn
          permReq = $$ -> 
            @a 
              id: 'dnotif-perm'
              class: 'status-tmp-widget button'
              'Allow desktop notifications'
          fn = -> 
            window.webkitNotifications.requestPermission()
            permReq.remove()
          permReq.click fn
          $('#status').append permReq

      $().toastmessage position: 'bottom-right'

      this
    notice  : (msg)->
      if @_hasNativeEnabled()
        @_notifyNative 'notice', msg
      else
        $().toastmessage 'showNoticeToast', msg
      this
    success : (msg)->
      if @_hasNativeEnabled()
        @_notifyNative 'success', msg
      else
        $().toastmessage 'showSuccessToast', msg
      this
    warning : (msg)->
      if @_hasNativeEnabled()
        @_notifyNative 'warning', msg
      else
        $().toastmessage 'showWarningToast', msg
      this
    error   : (msg)->
      if @_hasNativeEnabled()
        @_notifyNative 'error', msg
      else
        $().toastmessage 'showErrorToast', msg
      this
