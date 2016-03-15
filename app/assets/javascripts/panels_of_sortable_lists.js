/*
 * replace two panels with checkboxes for connections ("donees" and "donors"; "unused" is hidden)
 * with three panels (donnes | unused | donors)
 * allowing user to drag and drop connections on these list
 * donors_list and donee_lists aare the send with submit
 */


function create_3_panels(selectors_hash){

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
    	    	
      //console.log("UI.ITEM:"+ui.item.attr("id")+ui.item.prop("tagName"));
      if (ui.item.hasClass("connection")) {
        assign_connection_to_target_list(ui.item,$(event.target),selectors_hash);
      } else {
        if (ui.item.hasClass("group")) {
          move_all_group_connections_to_target_list(ui.item,$(event.target),selectors_hash);
        }
      }

      update_groups_according_to_connections(selectors_hash);
    }
 	});
}


//collect unchecked items from other lists and move them to unused list
function move_unchecked_items_to_unused(selectors_hash) {
  var li_item;
  $(selectors_hash['other_lists_arr'].join(", ")).each(function(){
    
    $(this).find('input[type="checkbox"]').each(function(){
      if($(this).is(":not(:checked)")){
      	set_new_conn_name_and_id($(this), "unused", selectors_hash);
        move_item_to($(this).closest("li"), $(selectors_hash['unused_list']+" ul") );
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
    console.log("TESTING: "+unused_conn.text()+" is in collections"+is_connection_already_in_collection(unused_conn, $(selectors_hash['other_lists_arr'].join(", ")) ));
    if(is_connection_already_in_collection(unused_conn,  other_list_items) ) {
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

//set correct ID and NAME according to list where item should be placed
function set_new_conn_name_and_id(item, replacement, selectors_hash) {

  //names :: ids of crucial inputs
  //wish_from_author[donee_conn_ids][] :: wish_from_author[donee_conn_ids][#{conn.id}]
  //wish_from_author[donor_conn_ids][] :: wish_from_author[donor_conn_ids][#{conn.id}]

  //loop trough all known list names and replace it with target name
  var list_selectors=[selectors_hash['unused_list']].concat(selectors_hash['other_lists_arr']);
  var new_id=item.attr("id");
  var new_name=item.attr("name");
  var replaced;
  
  for (index = 0; index < list_selectors.length; index++) {
    replaced=list_selectors[index].replace("#","").replace("_connections","").replace(" ",""); //get "donee", "donor", "unused" part 
    new_id=new_id.replace(replaced, replacement);
    new_name=new_name.replace(replaced, replacement);
  } 

  console.log(item.attr("id")+" => "+new_id );
  item.attr("id", new_id);
  item.attr("name", new_name);
}


function get_object_id_from(item) {
  var input_element=item;
  
  if(input_element.find("input").length != 0){
    //item is not the input itself
    input_element=input_element.find("input");
  }

  return input_element.val();
}

//search for item with same conn.id in list
function is_connection_already_in_collection(conn, collection){
  //console.log("looking for :"+conn.attr("id")+" in "+collection );
  var look_for_conn_id= get_object_id_from(conn);
  var this_conn_id;
  var result=false;
  collection.each(function(){
    this_conn_id=get_object_id_from($(this));
    console.log("comparing:"+this_conn_id+" == "+look_for_conn_id+" => "+(this_conn_id == look_for_conn_id) );
    if(this_conn_id == look_for_conn_id){
      result=true;
    };
  });
  return result;
}

function get_ids_of_checked_connections_from(collection) {
  var ids=[];
  
  collection.find(".connection input").each(function(){
    if ($(this).prop("checked")) {
      ids.push( get_object_id_from($(this)));
    } 
  });

  return ids.sort();
}

function get_ids_of_connections_from(collection) {
  var ids=[];
  
  collection.find(".connection input").each(function(){
    ids.push( get_object_id_from($(this)));
  });

  return ids.sort();
}

function are_all_group_connections_checked_in_collection(group_conn_ids, collection) {
  var checked_conn_ids = get_ids_of_connections_from(collection);
  console.log("group "+group_conn_ids+" is checked against:"+checked_conn_ids);
  for (var i = 0; i < group_conn_ids.length; i++) {
       if($.inArray(group_conn_ids[i], checked_conn_ids) == -1) {return false;}  
  }
  return true; //all ids form group are in collection
}


function check_and_move_group_to(conn_list, group){
  console.log("Moving "+group.attr("id")+" to "+conn_list.attr("id"));
  group.closest("li").prependTo(conn_list.find("ul"));
  group.prop("checked", true);
  group.find('input[type="checkbox"]').prop("checked", true);
};

//if all connection from group are in the collection, than move that group here too and check it
function move_and_check_groups(selectors_hash) {
  //loop through all groups (groups_of_connections must be defined)
  if (typeof groups_of_connections == 'undefined') {
    return false;
  }
  
  var other_lists =$(selectors_hash['other_lists_arr']);
  var conn_list;

  for (grp_id in groups_of_connections) {
    if (groups_of_connections.hasOwnProperty(grp_id)) {
      console.log("checking group:"+groups_of_connections[grp_id]);
      
      //check all 'nonused' panels for it's connections (only checked conns!)
      for (var i = 0; i < other_lists.length; i++) {
        conn_list = $(selectors_hash['other_lists_arr'][i]);
        console.log("checking list:"+conn_list.attr("id"));
        if (are_all_group_connections_checked_in_collection(groups_of_connections[grp_id], conn_list)) {
          console.log("group "+groups_of_connections[grp_id]+" is in  list:"+conn_list.attr("id"));
          group_sort_item=$("#groups_"+grp_id);
          check_and_move_group_to(conn_list, group_sort_item);
        };
      };
    };  
  };
};



function move_item_to(li_item, target_ul ){
  var chbx_item=li_item.find('input[type="checkbox"]');

  //if it is not yet there, move it to unused
  if(target_ul.find("#"+chbx_item.attr("id")).length == 0 ){
    
    if(li_item.hasClass("group")){
      li_item.prependTo("#"+target_ul.attr("id"));
    } else {
     li_item.appendTo("#"+target_ul.attr("id"));
    }
  }else{
    //just remove it
    li_item.remove();
  }
}

function update_groups_according_to_connections(selectors_hash) {
  var grp_li, grp_chbx, grp_conns, cons_in_list;

  console.log("grpsel: "+selectors_hash['lists_container']+" li.group");
  
  $(selectors_hash['lists_container']+" li.group").each(function(){
    update_group_according_to_connections_in_its_list($(this));
  });  
}

function update_group_according_to_connections_in_its_list(grp_li){
  grp_chbx=grp_li.find('input');
  console.log("updatig group: "+grp_chbx.val()+"    "+grp_chbx.attr("id"));

  group_conn_ids=groups_of_connections[grp_chbx.val()];
  console.log("grp_conns: "+group_conn_ids);

  var all_conns_are_here=are_all_group_connections_checked_in_collection(group_conn_ids, grp_li.parent());
  console.log("all_conns_are_here: "+all_conns_are_here);

  if(all_conns_are_here){
    //complete group
    grp_li.removeClass("group_incomplete");
  } else {
    //uncomplete group
    grp_li.addClass("group_incomplete");
  }
};

function assign_connection_to_target_list(li_item, target_ul,selectors_hash ){
  var item_dropped=li_item.find("input");
  var replacement= target_ul.attr("id").replace("_conn_ids","");
   
  set_new_conn_name_and_id(item_dropped, replacement, selectors_hash);
}

function move_all_group_connections_to_target_list(li_item, target_ul, selectors_hash){
   //loop through all groups (groups_of_connections must be defined)
  if (typeof groups_of_connections == 'undefined') {
    return false;
  }
 
  var group_conn_ids=groups_of_connections[get_object_id_from(li_item)];
  var conn_li_item;

  var remove_conns_from_uls = [];
  $(selectors_hash['lists_container']+" ul").each(function(){
    if($(this).attr("id") != target_ul.attr("id")) {
      remove_conns_from_uls.push("#"+$(this).attr("id"));
    }
  })
    

  console.log("connections "+group_conn_ids+" are moved to:"+target_ul.attr("id")+"from "+remove_conns_from_uls);
  var regexp_for_id; 
  $(remove_conns_from_uls.join(", ")).find("li.connection input").each(function(){
    console.log("input "+$(this).attr("id"));    

    for (var i = 0; i < group_conn_ids.length; i++) {
      console.log("input "+$(this).attr("id")+": "+group_conn_ids[i]);    
      
      regexp= new RegExp("_"+group_conn_ids[i]+"$");
      if (regexp.test($(this).attr("id"))) {
        console.log("input "+$(this).attr("id")+" matched "+group_conn_ids[i]);    
        assign_connection_to_target_list($(this).closest("li"), target_ul, selectors_hash )
        move_item_to( $(this).closest("li"), target_ul )  
      }
    }
  });   

};


function create_3_panel_selection(selectors_hash) {
  if($(selectors_hash['lists_container']).length != 0) {
    create_3_panels(selectors_hash);
    move_unchecked_items_to_unused(selectors_hash);
    remove_duplicates_between_lists(selectors_hash);
    move_and_check_groups(selectors_hash);
    hide_checkboxes(selectors_hash);
    update_groups_according_to_connections(selectors_hash);
  }
}

