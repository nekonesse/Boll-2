var event_id = async_load[? "id"]

if global.socket == event_id {
	var buff = async_load[? "buffer"]
	buffer_seek(buff, buffer_seek_start, 0)
	
	var _json=buffer_read(buff, buffer_string);
	//show_debug_message(_json);
	var _struct=json_parse(_json)
	show_debug_message(_struct);
	if !is_undefined(_struct[$ "type"]) {
		var _type=_struct[$ "type"]
		switch(_type) {
			case "ip_already_connected": {
				show_message("You were kicked:\nIP already connected to server.")
				game_end();
			} break;
			case "server_disconnect": {
				show_message("The experiment has been concluded.\nThank you for participating.")
				game_end();
			} break;
			case "curs_upd":
			cursors = _struct[$ "cursorstruct"];
			cursorexclusion=_struct[$ "exclusion"];
			break;
			case "level_sync":
			room_goto(rEditor)
			connected=true;
			levelstruct=_struct;
			alarm[1]=-1;
			alarm[0]=2;
			time=_struct[$ "time"];
			global.actions_left=_struct[$ "actions"];
			break;
			case "sync_actions":
			time=_struct[$ "time"];
			global.actions_left=_struct[$ "actions"];
			break;
			case "obj_pl":
			with(oJADEController) {
				place_object(_struct.uuid,_struct._x,_struct._y,_struct._xscale,_struct._yscale);
			}
			break;
			case "obj_del":
			with(oJADEController) {
				var size = ds_list_size(object_layer_map)
				var i=0;
				repeat(size) {
					var obj = ds_list_find_value(object_layer_map, i)
					if !is_undefined(obj) {
						if obj[1] == _struct._x && obj[2] == _struct._y {
							ds_list_delete(object_layer_map, i)
							break;
						}
					}
					i++;
				}
			}
			break;
			case "node_pl":
			with(oJADEController) {
				place_node_object(_struct.uuid,_struct._x,_struct._y,_struct._xscale,_struct._yscale);
			}
			break;
			case "node_del":
			with(oJADEController) {
				var size = ds_list_size(node_layer_map)
				var i=0;
				repeat(size) {
					var obj = ds_list_find_value(node_layer_map, i)
					if !is_undefined(obj) {
						if obj[1] == _struct._x && obj[2] == _struct._y {
							ds_list_delete(node_layer_map, i)
							break;
						}
					}
					i++;
				}
			}
			break;
			case "tile_pl":
			with(oJADEController) {
				place_tile(_struct.uuid,_struct._layer,_struct._x,_struct._y);
			}
			break;
			case "tile_del":
			with(oJADEController) {
				var data = tilemap_get(tile_layer[_struct._layer], _struct._x, _struct._y);
				if tile_get_index(data)!= 0 {
					data = tile_set_empty(data)
					tilemap_set(tile_layer[_struct._layer], data, _struct._x, _struct._y);
				}
			}
			break;
			case "tile_fl":
			with(oJADEController) {
				var data = tilemap_get(tile_layer[_struct._layer], _struct._x, _struct._y);
				if tile_get_index(data)!= 0 {
					data = tile_set_flip(data, 1 - tile_get_flip(data))
					tilemap_set(tile_layer[_struct._layer], data, _struct._x, _struct._y);
				}
			}
			break;
			case "tile_mi":
			with(oJADEController) {
				var data = tilemap_get(tile_layer[_struct._layer], _struct._x, _struct._y);
				if tile_get_index(data)!= 0 {
					data = tile_set_mirror(data, 1 - tile_get_mirror(data))
					tilemap_set(tile_layer[_struct._layer], data, _struct._x, _struct._y);
				}
			}
			break;
			case "tile_rot":
			with(oJADEController) {
				var data = tilemap_get(tile_layer[_struct._layer], _struct._x, _struct._y);
				if tile_get_index(data)!= 0 {
					data = tile_set_rotate(data, 1 - tile_get_rotate(data))
					tilemap_set(tile_layer[_struct._layer], data, _struct._x, _struct._y);
				}
			}
			break;
			case "obj_prop_change":
			with(oJADEController) {
				var size = ds_list_size(object_layer_map)
				var i=0;
				repeat(size) {
					var obj = ds_list_find_value(object_layer_map, i)
					if !is_undefined(obj) {
						if obj[0] == _struct.uuid && obj[1] == _struct._x && obj[2] == _struct._y {
							obj[10][_struct._slot][2]=_struct._value;
							break;
						}
					}
					i++;
				}
			}
			break;
			case "node_prop_change":
			with(oJADEController) {
				var size = ds_list_size(node_layer_map)
				var i=0;
				repeat(size) {
					var obj = ds_list_find_value(node_layer_map, i)
					if !is_undefined(obj) {
						if obj[0] == _struct.uuid && obj[1] == _struct._x && obj[2] == _struct._y {
							obj[10][_struct._slot][2]=_struct._value;
							break;
						}
					}
					i++;
				}
			}
			break;
			case "node_var_change":
			with(oJADEController) {
				var size = ds_list_size(object_layer_map)
				var i=0;
				repeat(size) {
					var obj = ds_list_find_value(object_layer_map, i)
					if !is_undefined(obj) {
						if obj[0] == _struct.uuid && obj[1] == _struct._x && obj[2] == _struct._y {
							obj[12][_struct._slot]=_struct._value;
							break;
						}
					}
					i++;
				}
			}
			break;
			case "obj_node_make":
			with(oJADEController) {
				var size = ds_list_size(object_layer_map)
				var i=0;
				repeat(size) {
					var obj = ds_list_find_value(object_layer_map, i)
					if !is_undefined(obj) {
						if obj[0] == _struct.uuid && obj[1] == _struct._x && obj[2] == _struct._y {
							obj[11][_struct._slot]=_struct._value;
							if drawing_node==i {
								var length = array_length(obj[11])-1;
								draw_node_x=obj[11][length][0]+((obj[6]-16)/2);
								draw_node_y=obj[11][length][1]+((obj[7]-16)/2);
							}
							break;
						}
					}
					i++;
				}
			}
			break;
			case "obj_node_del":
			with(oJADEController) {
				var size = ds_list_size(object_layer_map)
				var i=0;
				repeat(size) {
					var obj = ds_list_find_value(object_layer_map, i)
					if !is_undefined(obj) {
						if obj[0] == _struct.uuid && obj[1] == _struct._x && obj[2] == _struct._y {
							if array_length(obj[11]) {
								array_delete(obj[11],_struct._slot,1);
								if drawing_node==i {
									var length = array_length(obj[11])-1;
									draw_node_x=obj[11][length][0]+((obj[6]-16)/2);
									draw_node_y=obj[11][length][1]+((obj[7]-16)/2);
								}
								if !array_length(obj[11]) drawing_node=-1;
							}
							break;
						}
					}
					i++;
				}
			}
			break;
		}
	}
}