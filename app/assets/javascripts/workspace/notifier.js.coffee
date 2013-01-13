define ['toastmessage'], ->
  class Notifier
    init    : ->
      $().toastmessage position: 'bottom-right'
      this
    notice  : (msg)-> $().toastmessage('showNoticeToast', msg);
    success : (msg)-> $().toastmessage('showSuccessToast', msg);
    warning : (msg)-> $().toastmessage('showWarningToast', msg);
    error   : (msg)-> $().toastmessage('showErrorToast', msg);
