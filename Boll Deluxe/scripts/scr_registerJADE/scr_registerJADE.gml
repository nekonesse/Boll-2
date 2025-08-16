#macro OBJECT_MODE 0
#macro DECO_MODE 1
#macro NODE_MODE 2
#macro JADE_VERSION 4

function JADE_initializeobj() {
	obj_data = {};
	properties = new JADEproperties()
	objectlist = new JADElisthandler(1196,56, 228, 640, "selected_obj")
	decolist = new JADElisthandler(1196,56, 228, 640, "selected_obj")
	propertylist = new JADEpropertylisthandler(1196,56, 228, 640);
	
	list_tabbuttons=new JADEsmallbuttons(1196,38,96,20,16,false, true)
	list_tabbuttons.add("Object List", function() {
		properties_tab_active = false;
	});
	list_tabbuttons.add("Properties", function() {
		properties_tab_active = true;
	});
	list_tabbuttons.selected_button=0
	
	registerobj(oPlayerSpawn, spr_spawner, 8, 8, 16, 16, false, false, objectlist, "Player Spawn")
	registerobj(oCollider, spr_collider, 0, 0, 16, 16, true, true, objectlist, "Collider")
	registerobj(oSlopeCollider, spr_slopesolid, 0, 0, 16, 16, true, true, objectlist, "Slope Collider")
	
	var blockcategory = new JADElistcategory("Blocks")
	registerobj(oBrick, spr_brick, 8, 8, 16, 16, false, false, blockcategory, "Brick Block")
	registerobj(oItemBox, spr_itembox, 8, 8, 16, 16, false, false, blockcategory, "Item Box")
	properties.addDropdown(oItemBox, "Content", "content", "coin", ["Single Coin", "Multiple Coins", "Super Mushroom", "Fire Flower", "Thunder Flower", "Starman", "1UP Mushroom", "3UP Moon", "Poison Mushrom"], ["coin", "multicoins", "mushroom", "fireflower", "thunderflower", "star", "1up", "3up", "poison"])
	properties.addNumberInput(oItemBox, "Amount", "amount", 1, true)
	properties.addCheckbox(oItemBox, "Is Brick", "bricked", false)
	properties.addCheckbox(oItemBox, "Is Hidden", "hidden", false)
	properties.addCheckbox(oItemBox, "Is Dispenser", "eject", false)
	registerobj(oLongItemBox, spr_longitembox, 24, 8, 48, 16, false, false, blockcategory, "Long Item Box")
	registerobj(oMonitor, spr_monitor, 8, 8, 16, 16, false, false, blockcategory, "Monitor")
	
	objectlist.add(blockcategory) //we added the items to the category, but we still need to apply the category to the main list

	//add tilesets
	tilesets[$ "tTilesetMain"]=[spr_TilesetMain, tTilesetMain, "Floragrande Tiles"]
	tilesets[$ "tTilesetPipes"]=[spr_TilesetPipes, tTilesetPipes, "Pipe Tiles"]
	tilesets[$ "tTilesetMainDeco"]=[spr_TilesetMainDeco, tTilesetMainDeco, "Floragrande Decoration"]
	tilesets[$ "tTilesetWorld5"]=[spr_TilesetWorld5, tTilesetWorld5, "Frigid Dark Tiles"]
}

function WM_initializeobj() {	
	/*obj_data = ds_map_create();
	obj_name = ds_list_create();
	
	#region Categories
		cat_blocks = ds_list_create();
		cat_tech = ds_list_create();
		cat_node = ds_list_create();
		
		jade_cats[OBJECT_MODE] = [cat_blocks, cat_tech];
		jade_cats[NODE_MODE] = [cat_node];
	#endregion


	show_debug_message("Registering JADE object list...")
	registerobj(object_get_name(oPlayerSpawn), spr_spawner, -sprite_get_xoffset(spr_spawner), -sprite_get_yoffset(spr_spawner), sprite_get_width(spr_spawner), sprite_get_height(spr_spawner), false, false, OBJECT_MODE, 0, object_get_properties("oPlayerSpawn"), "Player Spawn")
	registerobj(object_get_name(oCollider), spr_collider, -sprite_get_xoffset(spr_collider), -sprite_get_yoffset(spr_collider), sprite_get_width(spr_collider), sprite_get_height(spr_collider), true, true, OBJECT_MODE, 0, object_get_properties("oCollider"), "Collider")
	registerobj(object_get_name(oSlopeCollider), spr_slopesolid, -sprite_get_xoffset(spr_slopesolid), -sprite_get_yoffset(spr_slopesolid), sprite_get_width(spr_slopesolid), sprite_get_height(spr_slopesolid), true, true, OBJECT_MODE, 0, object_get_properties("oSlopeCollider"), "Solid Slope")
	
	registerobj(object_get_name(oScript), spr_scripttrigger, 0, 0, 16, 16, true, true, OBJECT_MODE, 1, object_get_properties("oScript"), "Script Block", true)
	registerobj(object_get_name(oCustomObject), spr_customobject, 0, 0, 16, 16, false, false, OBJECT_MODE, 1, object_get_properties("oCustomObject"), "Custom Object", true)
	
	//NODE MODE
	registerobj(object_get_name(oCameraRegion), spr_cameraregion, -sprite_get_xoffset(spr_cameraregion), -sprite_get_yoffset(spr_cameraregion), sprite_get_width(spr_cameraregion), sprite_get_height(spr_cameraregion), true, true, NODE_MODE, 0, object_get_properties("oCameraRegion"), "Camera Region")
	registerobj(object_get_name(oCameraBoundary), spr_cameraboundary, -sprite_get_xoffset(spr_cameraboundary), -sprite_get_yoffset(spr_cameraboundary), sprite_get_width(spr_cameraboundary), sprite_get_height(spr_cameraboundary), true, true, NODE_MODE, 0, object_get_properties("oCameraBoundary"), "Camera Boundary")
	*/
}

function registerobj(uuid,_sprite,_xoff,_yoff,_width,_height,_can_xscale,_can_yscale,_list,_name,_nodeable=false,_sizex=1,_sizey=1) {
	var _id=object_get_name(uuid)
	if is_undefined(obj_data[$ _id]) {
		obj_data[$ _id]=new JADEobj(_id,_sprite,_xoff,_yoff,_width,_height,_can_xscale,_can_yscale,_name,_nodeable,_sizex,_sizey)
		properties.initProperties(uuid)
		_list.add(obj_data[$ _id])
	} else {
		show_debug_message($"JADE object {object_get_name(uuid)} has already been initialized! Ignoring...")
	}
}

function JADE_save(file=game_save_id+"\save.jade") {
	file_delete(file)
	show_debug_message($"Saving JADE file to: {file}")
	var struct = {};
	var g=0;
	repeat(4) {
		var arrayObjects=[];
		var i;
		i=0;
		repeat(ds_list_size(object_layer_map[g])) {
		    array_push(arrayObjects, object_layer_map[g][| i])
			i++;
		}
		var arrayNodeObjects = [];
		i=0;
		repeat(ds_list_size(node_layer_map[g])) {
		    array_push(arrayNodeObjects, node_layer_map[g][| i])
			i++;
		}
		var arrayTiles=[];
		i=0;
		repeat(array_length(tile_layer_map[g])) {
			arrayTiles[i]=[];
			var j=0;
		    repeat(ds_list_size(tile_layer_map[g][i])) {
				array_push(arrayTiles[i], tile_layer_map[g][i][| j])
				j++;
			}
			i++;
		}
		var arrayTileLayers=[];
		i=0;
		repeat (array_length(layers[g])) {
		    array_push(arrayTileLayers, [layer_get_name(layers[g][i]), layer_get_depth(layers[g][i]), tileset_get_name(tilemap_get_tileset(tile_layer[g][i])), arrayTiles[i]])
			i++;
		}
		
		struct[$ $"region{g}"] = {
			objects: arrayObjects,
			node_objects: arrayNodeObjects,
			tile_layers: arrayTileLayers
		}
		g++;
	}
	struct[$ "version"]=JADE_VERSION
	show_debug_message(struct)
	var _json=json_stringify(struct); //compile all saved things
	var save_file = buffer_create(string_byte_length(_json), buffer_grow, 1);
	buffer_write(save_file, buffer_string, _json); //save compilation into a buffer
	var compressed = buffer_compress(save_file, 0, buffer_tell(save_file))
	buffer_save(compressed, file); //save buffer into the save file
	buffer_delete(save_file)
	buffer_delete(compressed)
	show_debug_message($"Successfully saved JADE file to: {file}!")
}

function JADE_load(file=game_save_id+"\save.jade") {
	if !file_exists(file) exit;
	var loaded = buffer_load(file)
	var save_file = buffer_decompress(loaded)
	var level_data = json_parse(buffer_read(save_file,buffer_string))
	show_debug_message($"Loading JADE file from: {file}")
	if !is_array(level_data) && is_struct(level_data) {
		var jadeversion = level_data[$ "version"]
		if jadeversion < 3 {
			var objects = level_data[$ "objects"] //read amount of objects
			var node_objects = level_data[$ "node_objects"] //read amount of node objects
			var tile_layers = level_data[$ "tile_layers"]
			ds_list_clear(object_layer_map[0]) //erase object map beforehand
			var i;
			i=0;
			repeat(array_length(objects)) { //load objects
		        var data = objects[i]
				data[5] = 0
				if array_length(data) >= 13 && array_length(data[12]) < 5 {
					data[12][5]=true
				}
				ds_list_add(object_layer_map[0],data)
				i++
			}
			i=0;
			repeat (array_length(tile_layers)) {
				tilemap_tileset(tile_layer[0][i], asset_get_index(tile_layers[i][2]))
				var tiles=tile_layers[i][3]
				if array_length(tiles) { // does it actually contain any tiles?
					var j=0;
					repeat (array_length(tiles)) { //loading tiles
						var data = tiles[j]
						var tiledata = tilemap_get(tile_layer[0][i], data[1], data[2]);
						tiledata = tile_set_index(tiledata, data[0])
						tilemap_set(tile_layer[0][i], tiledata, data[1], data[2]) //set tile at place
						ds_list_add(tile_layer_map[0][i], [data[0], data[1], data[2]]) //add tile to list at place
						j++;
					}
				}
				i++;
			}
			ds_list_clear(node_layer_map[0])
			i=0;
			repeat (array_length(node_objects)) { //load node object
				var data = node_objects[i]
				data[5] = 0
				ds_list_add(node_layer_map[0],data)
				i++;
			}
		} else {
			var g=0;
			repeat(4) {
				var rg=level_data[$ $"region{g}"]
				show_debug_message(rg)
				var objects = rg[$ "objects"] //read amount of objects
				var node_objects = rg[$ "node_objects"] //read amount of node objects
				var tile_layers = rg[$ "tile_layers"]
				ds_list_clear(object_layer_map[g]) //erase object map beforehand
				var i;
				i=0;
				repeat(array_length(objects)) { //load objects
			        var data = objects[i]
					data[5] = 0
					if array_length(data) >= 13 && array_length(data[12]) < 5 {
						data[12][5]=true
					}
					ds_list_add(object_layer_map[g],data)
					i++
				}
				i=0;
				repeat (array_length(tile_layers)) {
					tilemap_tileset(tile_layer[g][i], asset_get_index(tile_layers[i][2]))
					var tiles=tile_layers[i][3]
					if array_length(tiles) { // does it actually contain any tiles?
						var j=0;
						repeat (array_length(tiles)) { //loading tiles
							var data = tiles[j]
							var tiledata = tilemap_get(tile_layer[g][i], data[1], data[2]);
							tiledata = tile_set_index(tiledata, data[0])
							tilemap_set(tile_layer[g][i], tiledata, data[1], data[2]) //set tile at place
							ds_list_add(tile_layer_map[g][i], [data[0], data[1], data[2]]) //add tile to list at place
							j++;
						}
					}
					i++;
				}
				ds_list_clear(node_layer_map[g])
				i=0;
				repeat (array_length(node_objects)) { //load node object
					var data = node_objects[i]
					data[5] = 0
					ds_list_add(node_layer_map[g],data)
					i++;
				}
				g++;
			}
		}
	} else { #region Legacy Level Loading
		var object_arr_index=1;
		var tile_arr_index=2;
		var node_arr_index=3;
		var tile_layer_arr_index=4;
		var has_version=true;
		if array_length(level_data) < 5 { //legacy conversion
			has_version=false;
			object_arr_index=0;
			tile_arr_index=1;
			node_arr_index=2;
			tile_layer_arr_index=3;
		}
		var size = array_length(level_data[object_arr_index]) //read amount of objects
		var nodesize = array_length(level_data[node_arr_index]) //read amount of objects
		var tilesize = array_length(level_data[tile_arr_index]) //read amount of tiles
		var g=0;
		repeat(4) {
			ds_list_clear(object_layer_map[g])
			g++;
		}
		var i;
	
		i=0;
		repeat(size) { //load objects
	        var data = level_data[object_arr_index][i]
			data[5] = 0
			if array_length(data) >= 13 && array_length(data[12]) < 5 {
				data[12][5]=true
			}
			ds_list_add(object_layer_map[0],data)
			i++
		}
		if array_length(level_data) >= 4 {
		    i=0;
			repeat(tilesize) { //loading tiles
				tilemap_clear(tile_layer[0][i], 0) //erase tilemap beforehand
				var g=0;
				repeat(4) {
					ds_list_clear(tile_layer_map[g][2]) //erase tile map beforehand
					g++;
				}
				var j=0;
				tilemap_tileset(tile_layer[0][i], asset_get_index(level_data[tile_layer_arr_index][i][2]))
				repeat (array_length(level_data[tile_arr_index][i])) {
					var data = level_data[tile_arr_index][i][j]
				    tilemap_set(tile_layer[0][i],data[0],data[1],data[2])
					ds_list_add(tile_layer_map[0][i], [data[0], data[1], data[2]]) //add tile to list at place
					j++;
				}
				i++
			}
		} else { //legacy tile conversion
			tilemap_clear(tile_layer[0][2], 0) //erase tilemap beforehand
			var g=0;
			repeat(4) {
				ds_list_clear(tile_layer_map[g][2]) //erase tile map beforehand
				g++;
			}
			var j=0;
			repeat (array_length(level_data[tile_arr_index])) {
				var data = level_data[tile_arr_index][j]
				tilemap_set(tile_layer[0][2],data[0],data[1],data[2])
				ds_list_add(tile_layer_map[0][2], [data[0], data[1], data[2]]) //add tile to list at place
				j++;
			}
		}
		var g=0;
		repeat(4) {
			ds_list_clear(node_layer_map[g])
			g++;
		}
		i=0;
		repeat (nodesize) { //load node objects
	        var data = level_data[node_arr_index][i]
			data[5] = 0
			ds_list_add(node_layer_map[0],data)
			i++;
		}
	} #endregion
	buffer_delete(loaded)
	buffer_delete(save_file)
	show_debug_message($"Successfully loaded JADE file from: {file}!")
}

function tile_layer_alpha_check() {
	//This makes the tile layer transparent if you arent in tile mode by using layer scripts
	
	if !array_contains(oJADEController.layers[oJADEController.selected_region], layer) {
		shader_set(shd_alpha)
		var alpha = shader_get_uniform(shd_alpha, "alpha");
		shader_set_uniform_f(alpha,0)
	} else if oJADEController.selected_mode!=DECO_MODE || layer!=oJADEController.layers[oJADEController.selected_region][oJADEController.selected_tile_layer] {
		shader_set(shd_alpha)
		var alpha = shader_get_uniform(shd_alpha, "alpha");
		shader_set_uniform_f(alpha,0.33)
	}
}