//if .button-add is present, hide the .form-add
//when user click on .butoon-add, form is revealed 
$( document ).ready(function() {
	if ($(".form-add .add").length) {
		$(".form-add form").hide();
		$(".form-add .add").show();
		/*add onclick handler to reverse this action*/
		$(".form-add .add").on("click", function(){ 
	  	$(".form-add form").slideDown( 300 );
		  $(".form-add .add").hide();
		}); 
  };
});
