var event_id = async_load[? "id"]

if global.socket == event_id {
	var buff = async_load[? "buffer"]
	buffer_seek(buff, buffer_seek_start, 0)
	
	var _json=buffer_read(buff, buffer_text);
	show_debug_message(_json);
	var _struct=json_parse(_json)
	show_debug_message(is_struct(_struct));
	if !is_undefined(_struct[$ "type"]) {
		var _type=_struct[$ "type"]
		switch(_type) {
			case "level_sync":
			with(oJADEController) {
				JADE_load(_struct);
			}
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
				var data = tilemap_get(tilemap, gridx, gridy);
				if tile_get_index(data)!= 0 {
					data = tile_set_empty(data)
					tilemap_set(tilemap, data, gridx, gridy);
				}
			}
			break;
		}
	}
}