var event_id = async_load[? "id"]

if server == event_id {
	var type = async_load[? "type"]
	var sock = async_load[? "socket"]
	
	if (type == network_type_connect) {
		//initialize client here
		with(oJADEController) {
			JADE_transer_save(sock)
		}
		ds_list_add(sockets, sock)
	}
	
	if (type == network_type_disconnect) {
		ds_list_delete(sockets,ds_list_find_index(sockets,sock))
	}
} else {
	var sock = async_load[? "id"]
	global.onlinebuffer = async_load[? "buffer"]
	buffer_seek(global.onlinebuffer, buffer_seek_start, 0)
	var _json=buffer_read(global.onlinebuffer, buffer_string);
	var _struct=json_parse(_json)
	
	var i=0;
	repeat(ds_list_size(sockets)) {
		var p=sockets[| i]
		if sock!=p {
			send_struct(_struct, p)
		}
		i++;
	}
	show_debug_message(_struct);
	if !is_undefined(_struct[$ "type"]) {
		var _type=_struct[$ "type"]
		switch(_type) {
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
				tile_update_properties(_struct._layer);
			}
			break;
			case "tile_fl":
			with(oJADEController) {
				var data = tilemap_get(tile_layer[_struct._layer], _struct._x, _struct._y);
				if tile_get_index(data)!= 0 {
					data = tile_set_flip(data, 1 - tile_get_flip(data))
					tilemap_set(tile_layer[_struct._layer], data, _struct._x, _struct._y);
					ds_list_add(tile_layer_map[_struct._layer], [data, _struct._x, _struct._y])
				}
				tile_update_properties(_struct._layer);
			}
			break;
			case "tile_mi":
			with(oJADEController) {
				var data = tilemap_get(tile_layer[_struct._layer], _struct._x, _struct._y);
				if tile_get_index(data)!= 0 {
					data = tile_set_mirror(data, 1 - tile_get_mirror(data))
					tilemap_set(tile_layer[_struct._layer], data, _struct._x, _struct._y);
					ds_list_add(tile_layer_map[_struct._layer], [data, _struct._x, _struct._y])
				}
				tile_update_properties(_struct._layer);
			}
			break;
			case "tile_rot":
			with(oJADEController) {
				var data = tilemap_get(tile_layer[_struct._layer], _struct._x, _struct._y);
				if tile_get_index(data)!= 0 {
					data = tile_set_rotate(data, 1 - tile_get_rotate(data))
					tilemap_set(tile_layer[_struct._layer], data, _struct._x, _struct._y);
					ds_list_add(tile_layer_map[_struct._layer], [data, _struct._x, _struct._y])
				}
				tile_update_properties(_struct._layer);
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
							array_delete(obj[11],_struct._slot,1);
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