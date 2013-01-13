#= require toastmessage/javascript/jquery.toastmessage
$().toastmessage
  position: 'bottom-right'

window.notifier =
  notice  : (msg)-> $().toastmessage('showNoticeToast', msg);
  success : (msg)-> $().toastmessage('showSuccessToast', msg);
  warning : (msg)-> $().toastmessage('showWarningToast', msg);
  error   : (msg)-> $().toastmessage('showErrorToast', msg);
