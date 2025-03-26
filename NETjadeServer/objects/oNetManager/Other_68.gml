var event_id = async_load[? "id"]

if server == event_id {
	var type = async_load[? "type"]
	var sock = async_load[? "socket"]
	
	if (type == network_type_connect) {
		//initialize client here
		ds_list_add(sockets, sock)
	}
	
	if (type == network_type_disconnect) {
		ds_list_delete(sockets,ds_list_find_index(sockets,sock))
	}
} else {
	var sock = async_load[? "id"]
	global.onlinebuffer = async_load[? "buffer"]
	buffer_seek(global.onlinebuffer, buffer_seek_start, 0)
	var _json=buffer_read(global.onlinebuffer, buffer_text);
	
	var p = clients[? sock]
	var i=0;
	var key = ds_map_find_first(clients);
	repeat(ds_map_size(clients)) {
		if key!=p {
			send_struct(_json, clients[? key])
		}
		key = ds_map_find_next(clients, key);
		i++;
	}
	var _struct=json_parse(_json)
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
		}
	}
}