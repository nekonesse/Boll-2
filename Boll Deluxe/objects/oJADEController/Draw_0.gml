//draw awesome objects!!! yay!!!!!

for (var i = 0; i < ds_list_size(object_layer_map); ++i) {
	var obj = ds_list_find_value(object_layer_map, i)
	//show_debug_message(obj)
	var sprite = ds_map_find_value(obj_data,obj[0])
	//show_debug_message(sprite)
    draw_sprite_ext(sprite[0], 0, (obj[1]*16)- sprite[2] , (obj[2]*16)- sprite[3], obj[3], obj[4], 0, c_white, 1)
	if selected_tool == ERASE_TOOL {
		var pos = 0
		pos.x = (obj[1]*16) 
		pos.y = (obj[2]*16)
		draw_rectangle_color(pos.x, pos.y, pos.x + 15, pos.y + 15, c_white,c_white,c_white,c_white, true)
	}
}