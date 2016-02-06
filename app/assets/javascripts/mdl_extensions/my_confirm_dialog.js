// Default confirm dialog from Rails Jquery_ujs, may be overridden with custom confirm dialog in $.rails.confirm
// I use mdl-jquery-modal-dialog.js

//Override the default confirm dialog by rails

//if link contains 'data-confirm' grab execution, otherwise leave it as it is
$.rails.allowAction = function(link){
  if (link.data("confirm") == undefined){
    return true;
  }
  $.rails.showConfirmationDialog(link);
  return false;
}


//User click confirm button
$.rails.confirmed = function(link){
  link.data("confirm", null);
  link.trigger("click.rails");
}

//Display the confirmation dialog
$.rails.showConfirmationDialog = function(link){
  var message = link.data("confirm");
  var ok_button_text = link.data("confirm-yes");
  var cancel_button_text = link.data("confirm-no");
  
  showDialog({
      id: 'confirm-dialog',
      title: '',
      text: message,
      negative: {
          id: 'cancel-button',
          title: cancel_button_text
      },
      positive: {
          id: 'ok-button',
          title: ok_button_text,
          onClick: function() { $.rails.confirmed(link);  }
      },
      cancelable: true,
      contentStyle: {'max-width': '500px'} //,
      //onLoaded: function() { ... }
  });
}
