function parse_level(dir=game_save_id+"\save.jade") {
	var file = dir
	if !file_exists(file) {
		show_message($"Level does not exist at {dir}! make sure you've saved first!")
		room_goto(rMainMenu)
	}
	var loaded = buffer_load(file)
	var save_file = buffer_decompress(loaded)
	var level_data = json_parse(buffer_read(save_file,buffer_string))
	show_debug_message($"Loading JADE level from: {file}")
	if is_struct(level_data) {
		var jadeversion = level_data[$ "version"]
		if (jadeversion == JADE_VERSION) {
			var layers = level_data[$ "layers"]
			var len=array_length(layers);
			var spawnpoints = array_create(4, 0);
			var i=0;
			repeat(len) {
				var _layer_contents = layers[i];
			
				var _layer;
			
				if (_layer_contents[0]!="MAIN") {
					if (_layer_contents[0] == "TILE") {
						_layer = {}
						_layer[$ "my_layer"] = layer_create(_layer_contents[3],_layer_contents[2])
						_layer[$ "my_deco_layer"] = layer_tilemap_create(_layer.my_layer,0,0,global.tilesets[$ _layer_contents[1]][1],ceil(room_width/16),ceil(room_height/16))
						_layer[$ "my_alpha"] = 1;
						_layer[$ "touched"] = false;
						
						if (array_length(_layer_contents) > 5) && (_layer_contents[5]) {
							layer_script_begin(_layer.my_layer, tile_layer_hidden_wall);
							layer_script_end(_layer.my_layer, tile_layer_alpha_end);
							array_push(oGameManager.hidden_tile_layers,_layer)
						}
						
						var tile_layer_contents = _layer_contents[4]
				
						var j=0;
						repeat(array_length(tile_layer_contents)) {
							tilemap_set(_layer.my_deco_layer, tile_layer_contents[j][0], tile_layer_contents[j][1], tile_layer_contents[j][2]);
							j++;
						}
					} else if (_layer_contents[0] == "ASSET") {
						_layer = {}
						_layer[$ "my_layer"] = layer_create(_layer_contents[2],_layer_contents[1])
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
						
						with(oBackgroundManager) {
							array_push(assetlayers, _layer)
						}
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
						with(oBackgroundManager) {
							array_push(bglayers, _layer);
							array_push(layers, _layer);
						}
					}
				} else {
					switch(_layer_contents[1]) {
						case "Piping Objects":
							oGameManager.piping_object_depth = 100*i
						break;
					}
				}
				i++;
			}
			
			//region count, change laters
			var objects = level_data[$ "objects"]
			var node_objects = level_data[$ "node_objects"]
			i=0
			repeat(array_length(objects)) {
				var j=0;
				repeat(array_length(objects[i])) {
					var data = objects[i][j]
					var objn = asset_get_index(data[0])
					if (objn == oPlayerSpawn) {
						spawnpoints[0] = data[1]
						spawnpoints[1] = data[2]
						spawnpoints[2] = data[1]
						spawnpoints[3] = data[2]
					} else {
						var obj = instance_create_depth(data[1], data[2], 0, objn)
						if instance_exists(obj) {
							obj.image_xscale=data[3]*data[8]
							obj.image_yscale=data[4]*data[9]
							obj.xstart+=data[6]*obj.image_xscale;
							obj.ystart+=data[7]*obj.image_yscale;
							obj.x=obj.xstart
							obj.y=obj.ystart
						
							if (array_length(data)) > 10 {
								if array_length(data[10]) {
									var temparr = []
									array_copy(temparr,0,data[10],0,array_length(data[11]))
									variable_instance_set(obj, "pathing", temparr);
									if is_array(data[11]) {
										variable_instance_set(obj, "pathspd", data[11][0]);
										variable_instance_set(obj, "pathnum", data[11][1]);
										variable_instance_set(obj, "pathcanrev", data[11][2]);
										variable_instance_set(obj, "pathcanfall", data[11][3]);
										variable_instance_set(obj, "pathdraw", data[11][4]);
										variable_instance_set(obj, "pathstarted", data[11][5]);
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
					}
					j++;
				}
				j=0;
				repeat(array_length(node_objects[i])) {
					var data = node_objects[i][j]
					var objn = asset_get_index(data[0])
					var obj = instance_create_depth(data[1], data[2], 0, objn)
					if array_length(data) < 9 {
						data[8] = 1;
						data[9] = 1;
					}
					if instance_exists(obj) {
						obj.image_xscale=data[3]*data[8]
						obj.image_yscale=data[4]*data[9]
						obj.xstart+=data[6]*obj.image_xscale;
						obj.ystart+=data[7]*obj.image_yscale;
						obj.x=obj.xstart
						obj.y=obj.ystart
						/*if array_length(data[11]) {
							var temparr = []
							array_copy(temparr,0,data[11],0,array_length(data[11]))
							variable_instance_set(obj, "pathing", temparr);
							if is_array(data[12]) {
								variable_instance_set(obj, "pathspd", data[12][0]);
								variable_instance_set(obj, "pathcanrev", data[12][1]);
								variable_instance_set(obj, "pathnum", data[12][2]);
								variable_instance_set(obj, "pathcanfall", data[12][3]);
								variable_instance_set(obj, "pathdraw", data[12][4]);
								if array_length(data[12]) > 5
								variable_instance_set(obj, "pathstarted", data[12][5]);
								else variable_instance_set(obj, "pathstarted", true);
							}	
						}*/
						
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
				i++;
			}
		}
		
		if (!is_undefined(level_data[$ "spawnpoints"])) {
			spawnpoints = level_data[$ "spawnpoints"];
		}
		
		if (global.jade_testing) {
			instance_create_depth(spawnpoints[2], spawnpoints[3], 0, oPlayerSpawn);		
		} else {
			instance_create_depth(spawnpoints[0], spawnpoints[1], 0, oPlayerSpawn);
		}
							
	}
	var border=instance_create_depth(-16,-128,0,oLevelBorder)
	border.image_yscale=ceil(room_height/16)+16
	var border=instance_create_depth(room_width,-128,0,oLevelBorder)
	border.image_yscale=ceil(room_height/16)+16
	instance_activate_all()
	with(all) {event_user(15)}
	buffer_delete(loaded)
	buffer_delete(save_file)
	show_debug_message($"Successfully loaded JADE level from: {file}!")
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
					var alpha = shader_get_uniform(shd_alpha, "alpha");
					shader_set_uniform_f(alpha,_layer.my_alpha)
					break;
				}
				i++;
			}
		}
	}
}