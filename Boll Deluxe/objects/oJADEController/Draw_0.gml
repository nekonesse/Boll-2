//draw awesome objects!!! yay!!!!!

for (var i = 0; i < ds_list_size(object_layer_map); ++i) {
	var obj = ds_list_find_value(object_layer_map, i)
	
	var sprite = ds_map_find_value(obj_data,obj[0])
	
	//for some reason applying camera x and camera y to the second rectangle just doesnt work for some reason 
	
	if !rectangle_in_rectangle(obj[1]*16, obj[2]*16, (obj[1]*16)+(sprite[4]*obj[3])-camera_get_view_x(view_camera[0]),(obj[2]*16)+(sprite[5]*obj[4])-camera_get_view_y(view_camera[0]), 0, 0, camera_get_view_x(view_camera[0])+camera_get_view_width(view_camera[0]), camera_get_view_y(view_camera[0])+camera_get_view_height(view_camera[0]))
	continue;
	
    draw_sprite_ext(sprite[0], 0, (obj[1]*16)- sprite[2] + obj[8] , (obj[2]*16)- sprite[3] + obj[9], obj[3], obj[4], 0, c_white, selected_mode==OBJECT_MODE ? 1 : 0.33)
	if (obj[5]) && selected_tool == SELECT_TOOL {	
		draw_rect((obj[1]*16), (obj[2]*16), round(obj[6]/16)*16, round(obj[7]/16)*16, c_white, 0.5)
	}
	
	if selected_tool == ERASE_TOOL {
		var pos = 0
		pos.x = (obj[1]*16) 
		pos.y = (obj[2]*16)
		draw_rectangle_color(pos.x, pos.y, pos.x + 15, pos.y + 15, c_white,c_white,c_white,c_white, true)
	}
	if global.debug draw_text((obj[1]*16), (obj[2]*16), $"{obj[1]} {obj[2]}")
}