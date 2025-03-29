var event_id = async_load[? "id"]

if server == event_id {
	var type = async_load[? "type"]
	var sock = async_load[? "socket"]
	var ip = async_load[? "ip"]
	
	if (type == network_type_connect) {
		//initialize client here
		
		if ds_map_exists(current_clients, ip) {
			var _struct = {
				type: "ip_already_connected"
			}
			send_struct(_struct,sock);
			network_destroy(sock);
		} else {
			ds_list_add(sockets, sock)
			if !ds_map_exists(clients, ip) {
				ds_map_add(action_timers, ip, -1);
			}
			ds_map_add(clients, ip, sock)
			ds_map_add(current_clients, ip, sock);
			cursors[$ ds_list_find_index(sockets, sock)]=[0,0,0,""]
			with(oJADEController) {
				JADE_transer_save(sock, ip)
			}
		}
	}
	
	if (type == network_type_disconnect) {
		network_destroy(sock);
		ds_list_delete(sockets,ds_list_find_index(sockets,sock))
		ds_map_delete(current_clients, ip)
		struct_remove(cursors,ds_list_find_index(sockets, sock))
	}
} else {
	var sock = async_load[? "id"]
	var ip = async_load[? "ip"]
	global.onlinebuffer = async_load[? "buffer"]
	buffer_seek(global.onlinebuffer, buffer_seek_start, 0)
	var _json=buffer_read(global.onlinebuffer, buffer_string);
	var _struct=json_parse(_json)
	var _DONTSENDSTRUCT=false;
	
	if !is_undefined(_struct[$ "type"]) {
		var _type=_struct[$ "type"]
		switch(_type) {
			case "curs_upd":
				cursors[$ ds_list_find_index(sockets, sock)]=[floor(_struct._x),floor(_struct._y),_struct._tool,_struct._name];
			break;
			case "obj_pl":
				show_debug_message(action_timers[? ip]);
				if (action_timers[? ip]==-1) {
					action_timers[? ip]=(60*60);
				}
				var _newstruct = {
					type: "sync_actions",
					time: action_timers[? ip]
				}
				send_struct(_newstruct, sock);
				with(oJADEController) {
					place_object(_struct.uuid,_struct._x,_struct._y,_struct._xscale,_struct._yscale);
				}
			break;
			case "obj_del":
				if (action_timers[? ip]==-1) {
					action_timers[? ip]=(60*60);
				}
				var _newstruct = {
					type: "sync_actions",
					time: action_timers[? ip]
				}
				send_struct(_newstruct, sock);
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
				if (action_timers[? ip]==-1) {
					action_timers[? ip]=(60*60);
				}
				var _newstruct = {
					type: "sync_actions",
					time: action_timers[? ip]
				}
				send_struct(_newstruct, sock);
				with(oJADEController) {
					place_node_object(_struct.uuid,_struct._x,_struct._y,_struct._xscale,_struct._yscale);
				}
			break;
			case "node_del":
				if (action_timers[? ip]==-1) {
					action_timers[? ip]=(60*60);
				}
				var _newstruct = {
					type: "sync_actions",
					time: action_timers[? ip]
				}
				send_struct(_newstruct, sock);
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
				if (action_timers[? ip]==-1) {
					action_timers[? ip]=(60*60);
				}
				var _newstruct = {
					type: "sync_actions",
					time: action_timers[? ip]
				}
				send_struct(_newstruct, sock);
				with(oJADEController) {
					place_tile(_struct.uuid,_struct._layer,_struct._x,_struct._y);
				}
			break;
			case "tile_del":
				if (action_timers[? ip]==-1) {
					action_timers[? ip]=(60*60);
				}
				var _newstruct = {
					type: "sync_actions",
					time: action_timers[? ip]
				}
				send_struct(_newstruct, sock);
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
				if (action_timers[? ip]==-1) {
					action_timers[? ip]=(60*60);
				}
				var _newstruct = {
					type: "sync_actions",
					time: action_timers[? ip]
				}
				send_struct(_newstruct, sock);
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
				if (action_timers[? ip]==-1) {
					action_timers[? ip]=(60*60);
				}
				var _newstruct = {
					type: "sync_actions",
					time: action_timers[? ip]
				}
				send_struct(_newstruct, sock);
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
				if (action_timers[? ip]==-1) {
					action_timers[? ip]=(60*60);
				}
				var _newstruct = {
					type: "sync_actions",
					time: action_timers[? ip]
				}
				send_struct(_newstruct, sock);
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
				if (action_timers[? ip]==-1) {
					action_timers[? ip]=(60*60);
				}
				var _newstruct = {
					type: "sync_actions",
					time: action_timers[? ip]
				}
				send_struct(_newstruct, sock);
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
				if (action_timers[? ip]==-1) {
					action_timers[? ip]=(60*60);
				}
				var _newstruct = {
					type: "sync_actions",
					time: action_timers[? ip]
				}
				send_struct(_newstruct, sock);
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
				if (action_timers[? ip]==-1) {
					action_timers[? ip]=(60*60);
				}
				var _newstruct = {
					type: "sync_actions",
					time: action_timers[? ip]
				}
				send_struct(_newstruct, sock);
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
				if (action_timers[? ip]==-1) {
					action_timers[? ip]=(60*60);
				}
				var _newstruct = {
					type: "sync_actions",
					time: action_timers[? ip]
				}
				send_struct(_newstruct, sock);
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
				if (action_timers[? ip]==-1) {
					action_timers[? ip]=(60*60);
				}
				var _newstruct = {
					type: "sync_actions",
					time: action_timers[? ip]
				}
				send_struct(_newstruct, sock);
				with(oJADEController) {
					var size = ds_list_size(object_layer_map)
					var i=0;
					repeat(size) {
						var obj = ds_list_find_value(object_layer_map, i)
						if !is_undefined(obj) {
							if obj[0] == _struct.uuid && obj[1] == _struct._x && obj[2] == _struct._y {
								if array_length(obj[11])
								array_delete(obj[11],_struct._slot,1);
								break;
							}
						}
						i++;
					}
				}
			break;
		}
		if !_DONTSENDSTRUCT {
			if _struct[$ "type"]!="curs_upd" {
				var i=0;
				repeat(ds_list_size(sockets)) {
					var p=sockets[| i]
					if sock!=p {
						send_struct(_struct, p)
					}
					i++;
				}
				show_debug_message(_struct);
			} else {
				var _newstruct = {
					type: "curs_upd",
					cursorstruct: cursors
				}
				var i=0;
				repeat(ds_list_size(sockets)) {
					var p=sockets[| i]
					if sock!=p {
						_newstruct[$ "exclusion"]=ds_list_find_index(sockets, p);
						send_struct(_newstruct, p)
					}
					i++;
				}
			}
		}
	}
}