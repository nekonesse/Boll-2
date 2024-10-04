#macro REGION_MODE 0
#macro OBJECT_MODE 1
#macro TILE_MODE 2
#macro BACKGROUND_MODE 3
#macro NODE_MODE 4

function JADE_initializeobj() {	
	obj_data = ds_map_create();
	obj_name = ds_list_create();
	
	#region Categories
		cat_blocks = ds_list_create();
		cat_baddies = ds_list_create();	
		cat_items = ds_list_create();
		cat_tech = ds_list_create();
		
		jade_cats = [cat_blocks, cat_baddies, cat_items, cat_tech];
	#endregion
	
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
	//3. placement x offset
	//4. placement y offset
	//5. placement xscale
	//6. placement yscale
	//7. scalable horizontally (bool)
	//8. scalable vertically (bool)
	//9. what editor mode object list to appear in
	//10. object properties (check scr_properties)
	show_debug_message("Registering JADE object list...")
	registerobj(object_get_name(oPlayerSpawn), spr_spawner, -sprite_get_xoffset(spr_spawner), -sprite_get_yoffset(spr_spawner), sprite_get_width(spr_spawner), sprite_get_height(spr_spawner), true, true, OBJECT_MODE, 0, object_get_properties("oPlayerSpawn"))
	registerobj(object_get_name(oCollider), spr_collider, -sprite_get_xoffset(spr_collider), -sprite_get_yoffset(spr_collider), sprite_get_width(spr_collider), sprite_get_height(spr_collider), true, true, OBJECT_MODE, 0, object_get_properties("oCollider"))
	registerobj(object_get_name(oSlopeCollider), spr_slopesolid, -sprite_get_xoffset(spr_slopesolid), -sprite_get_yoffset(spr_slopesolid), sprite_get_width(spr_slopesolid), sprite_get_height(spr_slopesolid), true, true, OBJECT_MODE, 0, object_get_properties("oSlopeCollider"))
	registerobj(object_get_name(oSemilider), spr_semilider, -sprite_get_xoffset(spr_semilider), -sprite_get_yoffset(spr_semilider), sprite_get_width(spr_semilider), sprite_get_height(spr_semilider), true, true, OBJECT_MODE, 0, object_get_properties("oSemilider"))
	registerobj(object_get_name(oSemiSlope), spr_slopesemi, -sprite_get_xoffset(spr_slopesemi), -sprite_get_yoffset(spr_slopesemi), sprite_get_width(spr_slopesemi), sprite_get_height(spr_slopesemi), true, true, OBJECT_MODE, 0, object_get_properties("oSemiSlope"))
	
	register_array(tag_get_asset_ids("blocks", asset_object), 0);
	register_array(tag_get_asset_ids("enemies", asset_object), 1);
	register_array(tag_get_asset_ids("items", asset_object), 2);
	register_array(tag_get_asset_ids("tech", asset_object), 3); //shoulda put the switch blocks in tech this one literally just has springs LOL
	
	//registerobj("collider", spr_collider, 0, 0, 0, 1, 1, true, true, OBJECT_MODE)
}

function register_array(array, category) {
	for (var i = 0; i < array_length(array); ++i) {
		var _name = object_get_name(array[i])
		var _sprite = object_get_sprite(array[i])
		var _properties = object_get_properties(_name)
	    registerobj(_name, _sprite, -sprite_get_xoffset(_sprite), -sprite_get_yoffset(_sprite), sprite_get_width(_sprite), sprite_get_height(_sprite), true, true, OBJECT_MODE, category, _properties)
	}	
}

function registerobj(uuid,sprite,xoff,yoff,xscale,yscale,can_xscale,can_yscale,mode,category,properties) {
	if !ds_map_exists(obj_data,uuid) {
		ds_map_add(obj_data,uuid,[sprite,xoff,yoff,xscale,yscale,can_xscale,can_yscale,mode,properties])
		ds_list_add(obj_name,uuid)
		ds_list_add(jade_cats[category],uuid)
		show_debug_message($"Successfully registered object id: {uuid} in JADE")
	} else {
		show_debug_message($"Object ID: {uuid} is already registered in JADE! ignoring..")
	}
}

function JADE_save(file=working_directory+"\save.jade") {
	file_delete(file)
	var save_file = file_text_open_write(file)
	show_debug_message($"Saving JADE file to: {file}")
	var size = ds_list_size(object_layer_map)
	var tilesize = ds_list_size(tile_layer_map)
	file_text_write_string(save_file, size) //amount of objects
	file_text_writeln(save_file)
	file_text_write_string(save_file, tilesize) //amounts of tiles
	file_text_writeln(save_file)
	for (var i = 0; i < size; ++i) { //object saving
		var obj = ds_list_find_value(object_layer_map, i)
		var _json_string = json_stringify(obj)
		file_text_write_string(save_file, _json_string)
		file_text_writeln(save_file)
	}
	for (var i = 0; i < tilesize; ++i) { //tilemap saving
		var tile = ds_list_find_value(tile_layer_map, i)
		show_debug_message(tile)
		var _json_string = json_stringify(tile)
		file_text_write_string(save_file, _json_string)
		file_text_writeln(save_file)
	}
	file_text_close(save_file);
	show_debug_message($"Successfully saved JADE file to: {file}!")
}

function JADE_load(file=working_directory+"\save.jade") {
	if !file_exists(file) exit;
	var save_file = file_text_open_read(file)
	show_debug_message($"Loading JADE file from: {file}")
	var size = unreal(file_text_read_string(save_file), 0) //read amount of objects
	file_text_readln(save_file)
	var tilesize = unreal(file_text_read_string(save_file), 0) //read amount of tiles
	file_text_readln(save_file)
	ds_list_clear(object_layer_map) //erase object map beforehand
	for (var i = 0; i < size; ++i) { //load objects
        var data = json_parse(file_text_read_string(save_file));
		data[5] = 0
		ds_list_add(object_layer_map,data)
        file_text_readln(save_file);
	}
	tilemap_clear(tilemap, 0) //erase tilemap beforehand
	ds_list_clear(tile_layer_map) //erase tile map beforehand
    for (var i = 0; i < tilesize; ++i) { //loading tiles
		var data = json_parse(file_text_read_string(save_file));
		tilemap_set(tilemap,data[0],data[1],data[2])
		ds_list_add(tile_layer_map, [data[0], data[1], data[2]]) //add tile to list at place
		file_text_readln(save_file);
	}
	file_text_close(save_file);
	show_debug_message($"Successfully loaded JADE file from: {file}!")
}