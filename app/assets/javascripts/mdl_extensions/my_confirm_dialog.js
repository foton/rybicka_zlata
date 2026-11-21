// Bridge for links still handled by jquery_ujs (data-confirm + data-method),
// e.g. activity_notification views: ask with the M3 dialog (window.rzConfirm
// from app/javascript/elements/rz_confirm.js), then let jquery_ujs continue.
// Remove together with jquery_ujs.
$.rails.allowAction = function(link) {
  var message = link.data("confirm");
  if (message === undefined || message === null) return true;
  if (!window.rzConfirm) return window.confirm(message);

  window.rzConfirm(message, { yes: link.data("confirm-yes"), no: link.data("confirm-no") })
    .then(function(confirmed) {
      if (!confirmed) return;
      link.data("confirm", null);
      link.trigger("click.rails");
    });
  return false;
};
