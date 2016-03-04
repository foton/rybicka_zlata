/*
 * replace two panels with checkboxes for connections ("donees" and "donors"; "unused" is hidden)
 * with three panels (donnes | unused | donors)
 * allowing user to drag and drop connections on these list
 * donors_list and donee_lists aare the send with submit
 */


function create_three_panels(selectors_hash){

  //set all blocks visible and with appropriate width
  $(selectors_hash['unused_list']+", "+selectors_hash['other_lists_arr'].join(", ")).each(function(){
    $(this).addClass("mdl-cell--4-col").removeClass("mdl-cell--6-col").show();
    $(this).find("ul").addClass("sortable-list");
  });  

  //add connected sortable to all lists
  $(selectors_hash['lists_container']+" .sortable-list").sortable({
    connectWith: selectors_hash['lists_container']+" .sortable-list",
    placeholder: "sortable_drop_placeholder",
    containment: selectors_hash['lists_container'],
    receive: function( event, ui ) {
    	var droped_on_list=$(event.target);
    	var item_dropped=ui.item.find("input");
    	var replacement= droped_on_list.attr("id").replace("_conn_ids","");
      
    	set_new_name_and_id(item_dropped, replacement, selectors_hash);
    }
 	});
}


//collect unchecked items from other lists and move them to unused list
function move_unchecked_items_to_unused(selectors_hash) {
  
  $(selectors_hash['other_lists_arr'].join(", ")).each(function(){
    
    $(this).find('input[type="checkbox"]').each(function(){
      if($(this).is(":not(:checked)")){
      	set_new_name_and_id($(this), "unused", selectors_hash);

      	//if it is not yet there, move it to unused
      	if($(selectors_hash['unused_list']).find("#"+$(this).attr("id")).length == 0 ){
          $(this).closest("li").appendTo("#unused_connections ul");
        }else{
        	//just remove it
        	$(this).closest("li").remove();
        }

  	  }
    });

  });
}

//remove item from unused list if it is present in other lists (compare by connection.id)
function remove_duplicates_between_lists(selectors_hash){
  var unused_conn;
  var other_list_items =$(selectors_hash['other_lists_arr'].join(", ")).find("li");
  $(selectors_hash['unused_list']).find('li').each(function(){
    unused_conn=$(this);
    console.log("TESTING: "+unused_conn.text()+" is in collections"+is_connection_in_collection(unused_conn, $(selectors_hash['other_lists_arr'].join(", ")) ));
    if(is_connection_in_collection(unused_conn,  other_list_items) ) {
      console.log("removing"+unused_conn.attr("id"));
      unused_conn.remove();
    }
  });  
}


function hide_checkboxes(selectors_hash){
  lists=$(selectors_hash['lists_container'])
  lists.find(".list-of-checkboxes").addClass("list-of-sortables").removeClass("list-of-checkboxes");
  lists.find("label.mdl-checkbox").attr('class', 'sortbox');
  lists.find("label.sortbox span.mdl-checkbox__label").removeClass("mdl-checkbox__label").addClass("label_text");
  lists.find("label.sortbox input").attr("type","hidden");
}

//set correct ID and NAME according to list where item is now placed
function set_new_name_and_id(item, replacement, selectors_hash) {

  //names :: ids of crucial inputs
  //wish_from_author[donee_conn_ids][] :: wish_from_author[donee_conn_ids][#{conn.id}]
  //wish_from_author[donor_conn_ids][] :: wish_from_author[donor_conn_ids][#{conn.id}]

  //loop trough all known list names and replace it with target name
  var list_selectors=[selectors_hash['unused_list']].concat(selectors_hash['other_lists_arr']);
  var new_id=item.attr("id");
  var new_name=item.attr("name");
  var replaced;
  
  for (index = 0; index < list_selectors.length; index++) {
    replaced=list_selectors[index].replace("#","").replace("_connections","").replace(" ","");
    new_id=new_id.replace(replaced, replacement);
    new_name=new_name.replace(replaced, replacement);
  } 

  console.log(item.attr("id")+" => "+new_id );
  item.attr("id", new_id);
  item.attr("name", new_name);
}


function get_conn_id_from(item) {
  var input_element=item;
  
  if(input_element.find("input").length != 0){
    //item is not the input itself
    input_element=input_element.find("input");
  }

  return input_element.val();
}

//search look for item with same conn.id in list
function is_connection_in_collection(conn, collection){
  //console.log("looking for :"+conn.attr("id")+" in "+collection );
  var look_for_conn_id= get_conn_id_from(conn);
  var this_conn_id;
  var result=false;
  collection.each(function(){
    this_conn_id=get_conn_id_from($(this));
    console.log("comparing:"+this_conn_id+" == "+look_for_conn_id+" => "+(this_conn_id == look_for_conn_id) );
    if(this_conn_id == look_for_conn_id){
      result=true;
    };
  });
  return result;
}



