#macro OBJECT_MODE 0
#macro DECO_MODE 1
#macro NODE_MODE 2
#macro JADE_VERSION 4

global.tilesets={}
//add tilesets
global.tilesets[$ "tTilesetMain"]=[spr_TilesetMain, tTilesetMain, "Floragrande Tiles"]
global.tilesets[$ "tTilesetPipes"]=[spr_TilesetPipes, tTilesetPipes, "Pipe Tiles"]
global.tilesets[$ "tTilesetMainDeco"]=[spr_TilesetMainDeco, tTilesetMainDeco, "Floragrande Decoration"]
global.tilesets[$ "tTilesetWorld5"]=[spr_TilesetWorld5, tTilesetWorld5, "Frigid Dark Tiles"]

function JADE_initializeobj() {
	obj_data = {};
	properties = new JADEproperties()
	objectlist = new JADElisthandler(1296-216-14,56, 216, 640, "selected_obj")
	gizmolist = new JADElisthandler(1296-216-14,56, 216, 640, "selected_obj")
	decolist = new JADElisthandler(1296-216-14,56, 216, 640, "selected_deco_obj")
	bglist = new JADEbglisthandler(1296-216-14,56, 216, 480)
	propertylist = new JADEpropertylisthandler(1296-216-14,56, 216, 640);
	
	list_tabbuttons=new JADEsmallbuttons(1296-216-14,38,96,20,8,false, true)
	
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
	properties.addDropdown(oItemBox, "Content", "content", "coin", ["Single Coin", "Multiple Coins", "Super Mushroom", "Fire Flower", "Thunder Flower", "Starman", "1UP Mushroom", "3UP Moon", "Poison Mushroom"], ["coin", "multicoins", "mushroom", "fireflower", "thunderflower", "star", "1up", "3up", "poison"])
	properties.addNumberInput(oItemBox, "Amount", "amount", 1, true)
	properties.addCheckbox(oItemBox, "Is Brick", "bricked", false)
	properties.addCheckbox(oItemBox, "Is Hidden", "hidden", false)
	properties.addCheckbox(oItemBox, "Is Dispenser", "eject", false)
	registerobj(oLongItemBox, spr_longitembox, 24, 8, 48, 16, false, false, blockcategory, "Long Item Box")
	registerobj(oMonitor, spr_monitor, 8, 8, 16, 16, false, false, blockcategory, "Monitor")
	
	objectlist.add(blockcategory) //we added the items to the category, but we still need to apply the category to the main list
	
	//NODE MODE
	registerobj(oCameraRegion, spr_cameraregion, 0, 0, 16, 16, false, false, gizmolist, "Camera Region")
	registerobj(oCameraBoundary, spr_cameraboundary, 0, 0, 16, 16, false, false, gizmolist, "Camera Boundary")
	registerobj(oActivationRegion, spr_activationregion, 0, 0, 16, 16, false, false, gizmolist, "Activation Region")
	registerobj(oDeactivationRegion, spr_deactivationregion, 0, 0, 16, 16, false, false, gizmolist, "Deactivation Regions")
	registerobj(oDeathPit, spr_deathpit, 0, 0, 16, 16, false, false, gizmolist, "Death Pit")
	
	//ASSETS
	registerasset(spr_bigwidetree, 8, 16, false, false, decolist, "Big Wide Tree")
	registerasset(spr_grass2, 0, 16, false, false, decolist, "2-Wide Grass")
	registerasset(spr_grass3, 8, 16, false, false, decolist, "3-Wide Grass")
	registerasset(spr_grass4, 0, 16, false, false, decolist, "4-Wide Grass")
	registerasset(spr_palmtree, 8, 16, false, false, decolist, "Palm Tree")
	registerasset(spr_palmtree2, 8, 16, false, false, decolist, "Palm Tree (2)")
	registerasset(spr_bigflower, 8, 16, false, false, decolist, "Big Flower")
	
	//BACKGROUNDS
	registerbackground(spr_plains_bg_hills, 0, 0, bglist,"Plains (Hills)",true,false,25,0,false,true)
	registerbackground(spr_plains_bg_hills2, 0, 0, bglist,"Plains (Front Hills)",true,false,40,0,false,true)
	registerbackground(spr_plains_bg_sky, 0, 0, bglist,"Plains (Sky)",true,false,0,0)
	registerbackground(spr_plains_bg_clouds, 0, 0, bglist,"Plains (Clouds)",true,false,10,0)
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
		show_debug_message($"JADE object {_id} has already been initialized! Ignoring...")
	}
}

function registerasset(_sprite,_xoff,_yoff,_can_xscale,_can_yscale,_list,_name,_sizex=1,_sizey=1) {
	var _id=sprite_get_name(_sprite)
	if is_undefined(obj_data[$ _id]) {
		var _width = sprite_get_width(_sprite);
		var _height = sprite_get_height(_sprite);
		obj_data[$ _id]=new JADEasset(_id,_sprite,_xoff,_yoff,_width,_height,_can_xscale,_can_yscale,_name,_sizex,_sizey)
		properties.initProperties(_sprite)
		_list.add(obj_data[$ _id])
	} else {
		show_debug_message($"JADE object {_id} has already been initialized! Ignoring...")
	}
}

function registerbackground(_sprite,_xoff,_yoff,_list,_name,_tiled_h=false,_tiled_v=false,_parallax_x=0,_parallax_y=0,_attach_x=false,_attach_y=false) {
	var _id=sprite_get_name(_sprite)
	if is_undefined(obj_data[$ _id]) {
		var _width = sprite_get_width(_sprite);
		var _height = sprite_get_height(_sprite);
		obj_data[$ _id]=new JADEbackground(_id,_sprite,_xoff,_yoff,_width,_height,_tiled_h,_tiled_v,_parallax_x,_parallax_y,_attach_x,_attach_y,_name)
		properties.initProperties(_sprite)
		_list.add(obj_data[$ _id])
	} else {
		show_debug_message($"JADE object {_id} has already been initialized! Ignoring...")
	}
}

function JADE_save(file=game_save_id+"\save.jade") {
	file_delete(file)
	show_debug_message($"Saving JADE file to: {file}")
	var struct = {};
	var layers = layerlist.listcontents;
	var layerarr = [];
	var i=0;
	repeat(array_length(layers)) {
		var _layer = layers[i];
		if !is_instanceof(_layer, JADElistunselectable) {
			if (is_instanceof(_layer, JADEtilelayer)) { 
				var tile_layer_contents = []; //wow!
				var j=0;
				repeat(ds_list_size(_layer.tilemap)) {
					array_push(tile_layer_contents,_layer.tilemap[| j])
					j++;
				}
				var _arr = ["TILE",_layer.tileset,_layer.name,_layer.layerdepth,tile_layer_contents]
				array_push(layerarr,_arr);
			} else if (is_instanceof(_layer, JADEassetlayer)) {
				var asset_layer_contents = []; //wow!
				var j=0;
				repeat(ds_list_size(_layer.assetmap)) {
					var uuid = _layer.assetmap[| j][0]
					var obj = _layer.assetmap[| j][1]
					var _x = layer_sprite_get_x(obj);
					var _y = layer_sprite_get_y(obj);
					var _xscale = layer_sprite_get_xscale(obj);
					var _yscale = layer_sprite_get_yscale(obj);
					var arr = [uuid,_x,_y,_xscale,_yscale]
					array_push(asset_layer_contents,arr)
					j++;
				}
				var _arr = ["ASSET",_layer.name,_layer.layerdepth,_layer.parallax_x,_layer.parallax_y,asset_layer_contents]
				array_push(layerarr,_arr);
			}
		} else {
			var _arr = ["MAIN",_layer.name]
			array_push(layerarr,_arr);
		}
		i++;
	}
	//region count, change later
	var obj_arr = [];
	var node_arr = [];
	i=0
	repeat(1) {
		obj_arr[i]=[];
		var j=0;
		repeat(ds_list_size(object_layer_map[i])) {
			array_push(obj_arr[i], object_layer_map[i][| j])
			j++;
		}
		node_arr[i]=[];
		j=0;
		repeat(ds_list_size(node_layer_map[i])) {
			array_push(node_arr[i], node_layer_map[i][| j])
			j++;
		}
		i++;
	}
	struct[$ "objects"] = obj_arr;
	struct[$ "node_objects"] = node_arr;
	struct[$ "layers"]=layerarr;
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
	if (level_data[$ "version"]==JADE_VERSION) {
		var layers = level_data[$ "layers"]
		layerlist.wipe();
		var len=array_length(layers);
		var i=0;
		repeat(len) {
			var _layer_contents = layers[i];
			
			var _layer;
			
			if (_layer_contents[0]!="MAIN") {
				if (_layer_contents[0] == "TILE") {
					_layer = new JADEtilelayer(_layer_contents[2],_layer_contents[1])
				
					var tile_layer_contents = _layer_contents[4]
				
					var j=0;
					repeat(array_length(tile_layer_contents)) {
						ds_list_add(_layer.tilemap, tile_layer_contents[j])
						tilemap_set(_layer.my_deco_layer, tile_layer_contents[j][0], tile_layer_contents[j][1], tile_layer_contents[j][2]);
						j++;
					}
				} else if (_layer_contents[0] == "ASSET") {
					_layer = new JADEassetlayer(_layer_contents[1])
				
					var asset_layer_contents = _layer_contents[5]
				
					var j=0;
					repeat(array_length(asset_layer_contents)) {
						var obj = asset_layer_contents[j]
						var data = obj_data[$ obj[0]];
						asset_place(obj[0],obj[1]-data.xoff,obj[2]-data.yoff,obj[3],obj[4],_layer)
						j++;
					}
				} else if (_layer_contents[0] == "BACK") {
					
				}
			} else {
				_layer = new JADElistunselectable(_layer_contents[1])
			}
			
			layerlist.add(_layer);
			i++;
		}
		layerlist.update_depths();
		//region count, change laters
		var objects = level_data[$ "objects"]
		var node_objects = level_data[$ "node_objects"]
		i=0
		repeat(array_length(objects)) {
			ds_list_clear(object_layer_map[i])
			ds_list_clear(node_layer_map[i])
			var j=0;
			repeat(array_length(objects[i])) {
				ds_list_add(object_layer_map[i], objects[i][j])
				j++;
			}
			j=0;
			repeat(array_length(node_objects[i])) {
				ds_list_add(node_layer_map[i], node_objects[i][j])
				j++;
			}
			i++;
		}
	}
	buffer_delete(loaded)
	buffer_delete(save_file)
	show_debug_message($"Successfully loaded JADE file from: {file}!")
}

function tile_layer_alpha_check() {
	//This makes the tile layer transparent if you arent in tile mode by using layer scripts
	if (oJADEController.selected_mode!=DECO_MODE || oJADEController.selected_layer == noone || layer!=oJADEController.selected_layer.my_layer) {
		shader_set(shd_alpha)
		var alpha = shader_get_uniform(shd_alpha, "alpha");
		shader_set_uniform_f(alpha,0.33)
	}
}