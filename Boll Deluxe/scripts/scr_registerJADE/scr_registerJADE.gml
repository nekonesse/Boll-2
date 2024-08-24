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

function JADE_save() {
	var file = working_directory+"\save.jade"
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

function JADE_load(dir=working_directory+"\save.jade") {
	var file = dir
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