//if .button-add is present, hide the .form-add
//when user click on .butoon-add, form is revealed 
$( document ).ready(function() {
	if ($(".form-add .button-add").length) {
		$(".form-add form").hide();
		$(".form-add .button-add").show();
		/*add onclick handler to reverse this action*/
		$(".form-add .button-add").on("click", function(){ 
	  	$(".form-add form").slideDown( 300 );
		  $(".form-add .button-add").hide();
		}); 
  };
});