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
	registerobj(object_get_name(oPlayerSpawn), spr_spawner, -sprite_get_xoffset(spr_spawner), -sprite_get_yoffset(spr_spawner), sprite_get_width(spr_spawner), sprite_get_height(spr_spawner), false, false, OBJECT_MODE, 0, object_get_properties("oPlayerSpawn"))
	registerobj(object_get_name(oCollider), spr_collider, -sprite_get_xoffset(spr_collider), -sprite_get_yoffset(spr_collider), sprite_get_width(spr_collider), sprite_get_height(spr_collider), true, true, OBJECT_MODE, 0, object_get_properties("oCollider"))
	registerobj(object_get_name(oSlopeCollider), spr_slopesolid, -sprite_get_xoffset(spr_slopesolid), -sprite_get_yoffset(spr_slopesolid), sprite_get_width(spr_slopesolid), sprite_get_height(spr_slopesolid), true, true, OBJECT_MODE, 0, object_get_properties("oSlopeCollider"))
	registerobj(object_get_name(oRoundedSlope1x1), spr_rslope1, -sprite_get_xoffset(spr_rslope1), -sprite_get_yoffset(spr_rslope1), sprite_get_width(spr_rslope1), sprite_get_height(spr_rslope1), true, true, OBJECT_MODE, 0, object_get_properties("oRoundedSlope1x1"))
	registerobj(object_get_name(oRoundedSlope2x2), spr_rslope2, -sprite_get_xoffset(spr_rslope2), -sprite_get_yoffset(spr_rslope2), sprite_get_width(spr_rslope2), sprite_get_height(spr_rslope2), true, true, OBJECT_MODE, 0, object_get_properties("oRoundedSlope2x2"))
	registerobj(object_get_name(oSemilider), spr_semilider, -sprite_get_xoffset(spr_semilider), -sprite_get_yoffset(spr_semilider), sprite_get_width(spr_semilider), sprite_get_height(spr_semilider), true, true, OBJECT_MODE, 0, object_get_properties("oSemilider"))
	registerobj(object_get_name(oSemiSlope), spr_slopesemi, -sprite_get_xoffset(spr_slopesemi), -sprite_get_yoffset(spr_slopesemi), sprite_get_width(spr_slopesemi), sprite_get_height(spr_slopesemi), true, true, OBJECT_MODE, 0, object_get_properties("oSemiSlope"))
	registerobj(object_get_name(oPipe), spr_pipe, -sprite_get_xoffset(spr_pipe), -sprite_get_yoffset(spr_pipe), sprite_get_width(spr_pipe), sprite_get_height(spr_pipe), false, false, OBJECT_MODE, 0, object_get_properties("oPipe"))
	registerobj(object_get_name(oItemBox), spr_itembox, -sprite_get_xoffset(spr_itembox), -sprite_get_yoffset(spr_itembox), sprite_get_width(spr_itembox), sprite_get_height(spr_itembox), false, false, OBJECT_MODE, 0, object_get_properties("oItemBox"))
	registerobj(object_get_name(oBrick), spr_brick, -sprite_get_xoffset(spr_brick), -sprite_get_yoffset(spr_brick), sprite_get_width(spr_brick), sprite_get_height(spr_brick), false, false, OBJECT_MODE, 0, object_get_properties("oBrick"))
	registerobj(object_get_name(oHardBlock), spr_hardblock, -sprite_get_xoffset(spr_hardblock), -sprite_get_yoffset(spr_hardblock), sprite_get_width(spr_hardblock), sprite_get_height(spr_hardblock), false, false, OBJECT_MODE, 0, object_get_properties("oHardBlock"))
	registerobj(object_get_name(oDonutBlock), spr_donutblock, -sprite_get_xoffset(spr_donutblock), -sprite_get_yoffset(spr_donutblock), sprite_get_width(spr_donutblock), sprite_get_height(spr_donutblock), true, false, OBJECT_MODE, 0, object_get_properties("oDonutBlock"))
	registerobj(object_get_name(oNoteBlock), spr_noteblock, -sprite_get_xoffset(spr_noteblock), -sprite_get_yoffset(spr_noteblock), sprite_get_width(spr_noteblock), sprite_get_height(spr_noteblock), false, false, OBJECT_MODE, 0, object_get_properties("oNoteBlock"))
	registerobj(object_get_name(oFlipblock), spr_flipblock, -sprite_get_xoffset(spr_flipblock), -sprite_get_yoffset(spr_flipblock), sprite_get_width(spr_flipblock), sprite_get_height(spr_flipblock), false, false, OBJECT_MODE, 0, object_get_properties("oFlipBlock"))
	registerobj(object_get_name(oShootBlock), spr_shootblock, -sprite_get_xoffset(spr_shootblock), -sprite_get_yoffset(spr_shootblock), sprite_get_width(spr_shootblock), sprite_get_height(spr_shootblock), false, false, OBJECT_MODE, 0, object_get_properties("oShootBlock"))
	registerobj(object_get_name(oSolidSpike), spr_solidspike, -sprite_get_xoffset(spr_solidspike), -sprite_get_yoffset(spr_solidspike), sprite_get_width(spr_solidspike), sprite_get_height(spr_solidspike), true, true, OBJECT_MODE, 0, object_get_properties("oSolidSpike"))
	registerobj(object_get_name(oMovingPlatform), spr_movingplatform, -sprite_get_xoffset(spr_movingplatform), -sprite_get_yoffset(spr_movingplatform), sprite_get_width(spr_movingplatform), sprite_get_height(spr_movingplatform), true, false, OBJECT_MODE, 0, object_get_properties("oMovingPlatform"))
	registerobj(object_get_name(oSwingingPlatform), spr_movingplatform, -sprite_get_xoffset(spr_movingplatform), -sprite_get_yoffset(spr_movingplatform), sprite_get_width(spr_movingplatform), sprite_get_height(spr_movingplatform), true, false, OBJECT_MODE, 0, object_get_properties("oSwingingPlatform"))
	registerobj(object_get_name(oChainsaw), spr_chainsaw, -8, -8, 16, 16, false, false, OBJECT_MODE, 0, object_get_properties("oChainsaw"))
	registerobj(object_get_name(oDirectionChanger), spr_directionchanger, -sprite_get_xoffset(spr_directionchanger), -sprite_get_yoffset(spr_directionchanger), sprite_get_width(spr_directionchanger), sprite_get_height(spr_directionchanger), false, false, OBJECT_MODE, 0, object_get_properties("oDirectionChanger"))
	
	registerobj(object_get_name(oTerrainSpreng), spr_yellowterrainspring, -sprite_get_xoffset(spr_yellowterrainspring), -sprite_get_yoffset(spr_yellowterrainspring), sprite_get_width(spr_yellowterrainspring), sprite_get_height(spr_yellowterrainspring), false, false, OBJECT_MODE, 3, object_get_properties("oTerrainSpreng"))
	registerobj(object_get_name(oTerrainSpring), spr_redterrainspring, -8, -16, 16, 16, false, false, OBJECT_MODE, 3, object_get_properties("oTerrainSpring"))
	registerobj(object_get_name(oTerrainSprong), spr_greenterrainspring, -8, -16, 16, 16, false, false, OBJECT_MODE, 3, object_get_properties("oTerrainSprong"))
	registerobj(object_get_name(oYellowSwitch), spr_yellowswitch, -sprite_get_xoffset(spr_yellowswitch), -sprite_get_yoffset(spr_yellowswitch), sprite_get_width(spr_yellowswitch), sprite_get_height(spr_yellowswitch), false, false, OBJECT_MODE, 3, object_get_properties("oYellowSwitch"))
	registerobj(object_get_name(oYellowSwitchBlock), spr_yellowswitchblock, -sprite_get_xoffset(spr_yellowswitchblock), -sprite_get_yoffset(spr_yellowswitchblock), sprite_get_width(spr_yellowswitchblock), sprite_get_height(spr_yellowswitchblock), false, false, OBJECT_MODE, 3, object_get_properties("oYellowSwitchBlock"))
	registerobj(object_get_name(oYellowSwitchBlockOff), spr_yellowswitchblockoff, -sprite_get_xoffset(spr_yellowswitchblockoff), -sprite_get_yoffset(spr_yellowswitchblockoff), sprite_get_width(spr_yellowswitchblockoff), sprite_get_height(spr_yellowswitchblockoff), false, false, OBJECT_MODE, 3, object_get_properties("oYellowSwitchBlockOff"))
	registerobj(object_get_name(oYellowSwitchSlope), spr_yellowswitchslope, -sprite_get_xoffset(spr_yellowswitchslope), -sprite_get_yoffset(spr_yellowswitchslope), sprite_get_width(spr_yellowswitchslope), sprite_get_height(spr_yellowswitchslope), false, false, OBJECT_MODE, 3, object_get_properties("oYellowSwitchSlope"))
	registerobj(object_get_name(oCyanSwitch), spr_cyanswitch, -sprite_get_xoffset(spr_cyanswitch), -sprite_get_yoffset(spr_cyanswitch), sprite_get_width(spr_cyanswitch), sprite_get_height(spr_cyanswitch), false, false, OBJECT_MODE, 3, object_get_properties("oCyanSwitch"))
	registerobj(object_get_name(oCyanSwitchBlock), spr_cyanswitchblock, -sprite_get_xoffset(spr_cyanswitchblock), -sprite_get_yoffset(spr_cyanswitchblock), sprite_get_width(spr_cyanswitchblock), sprite_get_height(spr_cyanswitchblock), false, false, OBJECT_MODE, 3, object_get_properties("oCyanSwitchBlock"))
	registerobj(object_get_name(oCyanSwitchBlockOff), spr_cyanswitchblockoff, -sprite_get_xoffset(spr_cyanswitchblockoff), -sprite_get_yoffset(spr_cyanswitchblockoff), sprite_get_width(spr_cyanswitchblockoff), sprite_get_height(spr_cyanswitchblockoff), false, false, OBJECT_MODE, 3, object_get_properties("oCyanSwitchBlockOff"))
	registerobj(object_get_name(oCyanSwitchSlope), spr_cyanswitchslope, -sprite_get_xoffset(spr_cyanswitchslope), -sprite_get_yoffset(spr_cyanswitchslope), sprite_get_width(spr_cyanswitchslope), sprite_get_height(spr_cyanswitchslope), false, false, OBJECT_MODE, 3, object_get_properties("oCyanSwitchSlope"))
	registerobj(object_get_name(oMagentaSwitch), spr_magentaswitch, -sprite_get_xoffset(spr_magentaswitch), -sprite_get_yoffset(spr_magentaswitch), sprite_get_width(spr_magentaswitch), sprite_get_height(spr_magentaswitch), false, false, OBJECT_MODE, 3, object_get_properties("oMagentaSwitch"))
	registerobj(object_get_name(oMagentaSwitchBlock), spr_magentaswitchblock, -sprite_get_xoffset(spr_magentaswitchblock), -sprite_get_yoffset(spr_magentaswitchblock), sprite_get_width(spr_magentaswitchblock), sprite_get_height(spr_magentaswitchblock), false, false, OBJECT_MODE, 3, object_get_properties("oMagentaSwitchBlock"))
	registerobj(object_get_name(oMagentaSwitchBlockOff), spr_magentaswitchblockoff, -sprite_get_xoffset(spr_magentaswitchblockoff), -sprite_get_yoffset(spr_magentaswitchblockoff), sprite_get_width(spr_magentaswitchblockoff), sprite_get_height(spr_magentaswitchblockoff), false, false, OBJECT_MODE, 3, object_get_properties("oMagentaSwitchBlockOff"))
	registerobj(object_get_name(oMagentaSwitchSlope), spr_magentaswitchslope, -sprite_get_xoffset(spr_magentaswitchslope), -sprite_get_yoffset(spr_magentaswitchslope), sprite_get_width(spr_magentaswitchslope), sprite_get_height(spr_magentaswitchslope), false, false, OBJECT_MODE, 3, object_get_properties("oMagentaSwitchSlope"))
	
	registerobj(object_get_name(oGoomba), spr_goombawalk, -8, -8, 16, 16, false, false, OBJECT_MODE, 1, object_get_properties("oGoomba"))
	registerobj(object_get_name(oGoombrat), spr_goombratwalk, -8, -8, 16, 16, false, false, OBJECT_MODE, 1, object_get_properties("oGoombrat"))
	registerobj(object_get_name(oKoopa), spr_koopawalk_g, -8, -8, 16, 16, false, false, OBJECT_MODE, 1, object_get_properties("oKoopa"))
	registerobj(object_get_name(oKoopaRed), spr_koopawalk_r, -8, -8, 16, 16, false, false, OBJECT_MODE, 1, object_get_properties("oKoopaRed"))
	registerobj(object_get_name(oKoopaYellow), spr_koopawalk_y, -8, -8, 16, 16, false, false, OBJECT_MODE, 1, object_get_properties("oKoopaYellow"))
	
	register_array(tag_get_asset_ids("blocks", asset_object), 0);
	register_array(tag_get_asset_ids("enemies", asset_object), 1);
	register_array(tag_get_asset_ids("items", asset_object), 2);
	register_array(tag_get_asset_ids("tech", asset_object), 3); //shoulda put the switch blocks in tech this one literally just has springs LOL

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
	show_debug_message($"Saving JADE file to: {file}")
	var array = [];
	var arrayObjects=[];
	for (var i = 0; i < ds_list_size(object_layer_map); ++i) {
	    array_push(arrayObjects, object_layer_map[| i])
	}
	var arrayTiles=[];
	for (var i = 0; i < ds_list_size(tile_layer_map); ++i) {
	    array_push(arrayTiles, tile_layer_map[| i])
	}
	array_push(array, arrayObjects)
	array_push(array, arrayTiles)
	show_debug_message(array)
	var _json=json_stringify(array); //compile all saved things
	var save_file = buffer_create(string_byte_length(_json), buffer_grow, 1);
	buffer_write(save_file, buffer_string, _json); //save compilation into a buffer
	var compressed = buffer_compress(save_file, 0, buffer_tell(save_file))
	buffer_save(compressed, file); //save buffer into the save file
	buffer_delete(save_file)
	buffer_delete(compressed)
	show_debug_message($"Successfully saved JADE file to: {file}!")
}

function JADE_load(file=working_directory+"\save.jade") {
	if !file_exists(file) exit;
	var loaded = buffer_load(file)
	var save_file = buffer_decompress(loaded)
	var array = json_parse(buffer_read(save_file,buffer_string))
	show_debug_message($"Loading JADE file from: {file}")
	var size = array_length(array[0]) //read amount of objects
	var tilesize = array_length(array[1]) //read amount of tiles
	ds_list_clear(object_layer_map) //erase object map beforehand
	for (var i = 0; i < size; ++i) { //load objects
        var data = array[0][i]
		data[5] = 0
		ds_list_add(object_layer_map,data)
	} 
	tilemap_clear(tilemap, 0) //erase tilemap beforehand
	ds_list_clear(tile_layer_map) //erase tile map beforehand
    for (var i = 0; i < tilesize; ++i) { //loading tiles
		var data = array[1][i]
		tilemap_set(tilemap,data[0],data[1],data[2])
		ds_list_add(tile_layer_map, [data[0], data[1], data[2]]) //add tile to list at place
	}
	buffer_delete(loaded)
	buffer_delete(save_file)
	show_debug_message($"Successfully loaded JADE file from: {file}!")
}