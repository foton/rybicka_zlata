//if .button-add is present, hide the .form-add
//when user click on .butoon-add, form is revealed 
$( document ).ready(function() {
	if ($(".form-add .new").length) {
		$(".form-add form").hide();
		$(".form-add .new").show();
		/*add onclick handler to reverse this action*/
		$(".form-add .new").on("click", function(){ 
	  	$(".form-add form").slideDown( 300 );
		  $(".form-add .new").hide();
		}); 
  };
});
