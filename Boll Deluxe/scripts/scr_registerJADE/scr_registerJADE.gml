#macro REGION_MODE 0
#macro OBJECT_MODE 1
#macro TILE_MODE 2
#macro BACKGROUND_MODE 3
#macro NODE_MODE 4



function JADE_intializeobj(){	
	obj_data=ds_map_create();
	obj_name = ds_list_create()	
	/*
		hey so let me explain how this works:
		uuid is the 'id' for an object, its used for accessing everything. preferrably a string. 
		DO NOT USE AN INSTANCE ID.
		gamemaker instance ids are dynamic and will regenerate when the game compiles,
		meaning if you try and save that and load it later, it will error, because it doesnt exist!
		
		instead use a string for a name like "brick" or "red_koopa"
	*/
	//1. uuid
	//2. sprite
	//3. atlas index (for object list)
	//4. placement x offset
	//5. placement y offset
	//6. placement xscale
	//7. placement yscale
	//8. scalable horizontally (bool)
	//9. scalable vertically (bool)
	//10. what editor mode object list to appear in
	show_debug_message("Registering JADE object list...")
	
	var obj_list1 = tag_get_asset_ids("blocks", asset_object);
	
	for (var i = 0; i < array_length(obj_list1); ++i) {
		var _name = object_get_name(obj_list1[i])
		var _sprite = object_get_sprite(obj_list1[i])
	    registerobj(_name, _sprite, 0, -sprite_get_xoffset(_sprite), -sprite_get_yoffset(_sprite), sprite_get_width(_sprite), sprite_get_height(_sprite), true, true, OBJECT_MODE)
	}
	//registerobj("collider", spr_collider, 0, 0, 0, 1, 1, true, true, OBJECT_MODE)
}

function registerobj(uuid,sprite,index,xoff,yoff,xscale,yscale,can_xscale,can_yscale,mode) {
	if !ds_map_exists(obj_data,uuid) {
		ds_map_add(obj_data,uuid,[sprite,index,xoff,yoff,xscale,yscale,can_xscale,can_yscale,mode])
		ds_list_add(obj_name,uuid)
		show_debug_message($"Successfully registered object id: {uuid} in JADE")
	} else {
		show_debug_message($"Object ID: {uuid} is already registered in JADE! ignoring..")
	}
}