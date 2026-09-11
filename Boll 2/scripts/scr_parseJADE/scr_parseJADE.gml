function parse_level(dir=game_save_id+"\save.jade") {
	var file = dir
	if !file_exists(file) {
		show_message($"Level does not exist at {dir}! make sure you've saved first!")
		if (demo_build)
             room_goto(rTECHDEMO_Disclaimer);
        else room_goto(rMainMenu);
	}
	var loaded = buffer_load(file)
	var save_file = buffer_decompress(loaded)
	var level_data = json_parse(buffer_read(save_file,buffer_string))
	show_debug_message($"Loading JADE level from: {file}")
	if is_struct(level_data) {
		var jadeversion = level_data[$ "version"]
		if (string_starts_with(jadeversion,"5")) {
			if (struct_exists(level_data, "level_properties")) {
				level_properties = level_data[$ "level_properties"]
				show_debug_message("LEVEL PROPERTIES LOADED!!! Level name: " + level_properties.name)
			} else {
				level_properties =
				{
				    name : "Danger Room",
				    desc : ""
				};
			}
			var r=0;
			var regionlist = level_data[$ "level_data"]
			var roomwidth = 0;
			var spawnpoints = array_create(4, 0);
			repeat(array_length(regionlist)) {
				var region = regionlist[r];
				var layers = region[$ "layers"]
				var len=array_length(layers);
				with(oGameManager) {
					music_tracks[r] = region[$ "music_track"];
					region_widths[r] = (region[$ "width"]*16);
					region_heights[r] = (region[$ "height"]*16);
					region_positions[r] = roomwidth;
					all_layers[r] = [];
					hidden_tile_layers[r] = [];
				}
				with(oBackgroundManager) {
					assetlayers[r] = [];
					bglayers[r] = [];
				}
				var i=0;
				repeat(len) {
					var _layer_contents = layers[i];
			
					var _layer;
			
					if (_layer_contents[0]!="MAIN") {
						if (_layer_contents[0] == "TILE") {
							_layer = {}
							_layer[$ "my_layer"] = layer_create(_layer_contents[3],_layer_contents[2])
							_layer[$ "my_deco_layer"] = layer_tilemap_create(_layer.my_layer,0,0,global.tilesets[$ _layer_contents[1]][1],region[$ "width"],region[$ "height"]);
							layer_x(_layer[$ "my_layer"],roomwidth);
							_layer[$ "my_alpha"] = 1;
							_layer[$ "touched"] = false;
						
							if (_layer_contents[5]) {
								layer_script_begin(_layer.my_layer, tile_layer_hidden_wall);
								layer_script_end(_layer.my_layer, tile_layer_alpha_end);
								array_push(oGameManager.hidden_tile_layers[r],_layer)
							}
						
							var tile_layer_contents = _layer_contents[4]
				
							var j=0;
							repeat(array_length(tile_layer_contents)) {
								tilemap_set(_layer.my_deco_layer, tile_layer_contents[j][0], tile_layer_contents[j][1], tile_layer_contents[j][2]);
								j++;
							}
							
							array_push(oGameManager.all_layers[r],_layer);
						} else if (_layer_contents[0] == "ASSET") {
							_layer = {}
							_layer[$ "my_layer"] = layer_create(_layer_contents[2],_layer_contents[1])
							layer_x(_layer[$ "my_layer"],roomwidth);
							_layer[$ "my_deco_layer"] = _layer.my_layer
							_layer.parallax_x = _layer_contents[3]
							_layer.parallax_y = _layer_contents[4]
				
							var asset_layer_contents = _layer_contents[5]
				
							var j=0;
							repeat(array_length(asset_layer_contents)) {
								var obj = asset_layer_contents[j]
								var inst = layer_sprite_create(_layer.my_layer,obj[1],obj[2],asset_get_index(obj[0]));
								layer_sprite_xscale(inst,obj[3]);
								layer_sprite_yscale(inst,obj[4]);
								j++;
							}
						
							array_push(oBackgroundManager.assetlayers[r], _layer)
							array_push(oGameManager.all_layers[r],_layer);
						} else if (_layer_contents[0] == "BACK") {
							_layer = {}
							var spr = spr_BGtest
							if (_layer_contents != -1) spr = asset_get_index(_layer_contents[3])
							_layer[$ "my_layer"] = layer_create(_layer_contents[2],_layer_contents[1])
							_layer[$ "my_deco_layer"] = layer_background_create(_layer.my_layer,spr)
							_layer.parallax_x = _layer_contents[4]
							_layer.parallax_y = _layer_contents[5]
							_layer.attach_x = _layer_contents[6]
							_layer.attach_y = _layer_contents[7]
							_layer.tiled_h = _layer_contents[8]
							_layer.tiled_v = _layer_contents[9]
							_layer.off_x = _layer_contents[10]
							_layer.off_y = _layer_contents[11]
							layer_x(_layer.my_layer,_layer.off_x);
							layer_y(_layer.my_layer,_layer.off_y);
							layer_background_htiled(_layer.my_deco_layer, _layer.tiled_h)
							layer_background_vtiled(_layer.my_deco_layer, _layer.tiled_v)
							array_push(oBackgroundManager.bglayers[r], _layer);
							array_push(oGameManager.all_layers[r],_layer);
						}
					} else {
						switch(_layer_contents[1]) {
							case "Piping Objects":
								oGameManager.piping_object_depth[r] = 100*i;
							break;
						}
					}
					i++;
				}
				
				var objects = region[$ "objects"]
				var node_objects = region[$ "node_objects"]
				
				var j=0;
				repeat(array_length(objects)) {
					var data = objects[j]
					var objn = asset_get_index(data[0])
					var xscale = data[3]*data[8]
					var yscale = data[4]*data[9]
					var obj = instance_create_depth(roomwidth+data[1]+data[6]*xscale, data[2]+data[7]*yscale, 0, objn);
					if instance_exists(obj) {
						obj.image_xscale=xscale;
						obj.image_yscale=yscale;
						obj.myregion = r;
						
						if (array_length(data)) > 10 {
							if array_length(data[10]) {
								var temparr = []
								array_copy(temparr,0,data[10],0,array_length(data[10]))
								variable_instance_set(obj, "pathing", temparr);
								if is_array(data[11]) {
									variable_instance_set(obj, "pathnum", data[11][0]);
									variable_instance_set(obj, "pathstarttype", data[11][1]);
									variable_instance_set(obj, "pathendtype", data[11][2]);
									variable_instance_set(obj, "pathdraw", data[11][3]);
								}	
							}
						}
						
						//object variables
						var g=0
						repeat(array_length(data[5])) {
							var propertydata = data[5][g]
							if variable_instance_exists(obj, propertydata[0]) {
								variable_instance_set(obj, propertydata[0], propertydata[1])
							}
							g++;
						}
					}
					j++;
				}
				
				j=0;
				repeat(array_length(node_objects)) {
					var data = node_objects[j]
					var objn = asset_get_index(data[0])
					var xscale = data[3]*data[8]
					var yscale = data[4]*data[9]
					var obj = instance_create_depth(roomwidth+data[1]+data[6]*xscale, data[2]+data[7]*yscale, 0, objn);
					if instance_exists(obj) {
						obj.image_xscale=xscale;
						obj.image_yscale=yscale;
						obj.myregion = r;
						
						//object variables
						var g=0
						repeat(array_length(data[5])) {
							var propertydata = data[5][g]
							if variable_instance_exists(obj, propertydata[0]) {
								variable_instance_set(obj, propertydata[0], propertydata[1])
							}
							g++;
						}
					}
					j++;
				}
				
				var width = (region[$ "width"]*16);
				var border=instance_create_depth(roomwidth-16,-128,0,oLevelBorder)
				border.image_yscale=region[$ "height"]+16;
				border.myregion = r;
				var border=instance_create_depth(roomwidth+width,-128,0,oLevelBorder)
				border.image_yscale=region[$ "height"]+16;
				border.myregion = r;
				
				roomwidth+=width+512;
				r++;
			}
		}
		
		if (!is_undefined(level_data[$ "spawnpoints"])) {
			spawnpoints = level_data[$ "spawnpoints"];
		}
		
		if (global.jade_testing) {
			instance_create_depth(spawnpoints[3], spawnpoints[4], 0, oPlayerSpawn, {
				myregion : spawnpoints[5]
			});
		} else {
			instance_create_depth(spawnpoints[0], spawnpoints[1], 0, oPlayerSpawn, {
				myregion : spawnpoints[2]
			});
		}
	}
	instance_activate_all()
	with(all) {event_user(15)}
	buffer_delete(loaded)
	buffer_delete(save_file)
	show_debug_message($"Successfully loaded JADE level from: {file}!")
}

function level_preparse(dir=game_save_id+"\save.jade") {
	var file = dir
	if !file_exists(file) {
		show_message($"Level does not exist at {dir}! make sure you've saved first!")
		if (demo_build)
             room_goto(rTECHDEMO_Disclaimer);
        else room_goto(rMainMenu);
	}
	var loaded = buffer_load(file)
	var save_file = buffer_decompress(loaded)
	var level_data = json_parse(buffer_read(save_file,buffer_string))
	var regionlist = level_data[$ "level_data"];
	var width = 0;
	var height = 0;
	var i=0;
	repeat(array_length(regionlist)) {
		var regionstruct = regionlist[i];
		width += (regionstruct[$ "width"]*16)+512;
		height = max(height,(regionstruct[$ "height"]*16)+512);
		room_set_width(rGame,width);
		room_set_height(rGame,height);
		i++;
	}
	buffer_delete(loaded)
	buffer_delete(save_file)
	show_debug_message($"Pre-loading JADE level from: {file}")
}

function tile_layer_hidden_wall() {
	if (event_type == ev_draw)
    {
        if (event_number == ev_draw_normal)
        {
			var hidden_layers = oGameManager.hidden_tile_layers
			var i=0;
			repeat(array_length(hidden_layers)) {
				var _layer = hidden_layers[i]
				if (layer == _layer.my_layer) && (_layer.my_alpha < 1) {
					shader_set(shd_alpha)
					static alpha = shader_get_uniform(shd_alpha, "alpha");
					shader_set_uniform_f(alpha,_layer.my_alpha)
					break;
				}
				i++;
			}
		}
	}
}