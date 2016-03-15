//expect list of checkboxes, splited into 2 lists ".list-of-unchecked" and ".list-of-unchecked"
//hides checkbox boxes
//and add onchange event which move changed item to corresponding list

function move_on_change($chkbx){
	var $lcheckboxes=$chkbx.closest(".lists-of-checkboxes_two-panels");
	var $lchecked=$lcheckboxes.find(".list-of-checked ul");
	var $lunchecked=$lcheckboxes.find(".list-of-unchecked ul");
	
	var to_list;
	
  var to_list=( $chkbx.is(":checked") ? $lchecked : $lunchecked );

  //to leave time for ripple effect
  setTimeout(function(){
    $chkbx.closest("li").appendTo(to_list);  
  },300);
  
}

function check_group_connection() {
  //find all connections in this list, which belong to group

  //and change theirs state to same as group have
}

$( document ).ready(function() {
	$(".lists-of-checkboxes").find("[type=checkbox]").on( "change", function() {
	  move_on_change( $(this));
	});
});
