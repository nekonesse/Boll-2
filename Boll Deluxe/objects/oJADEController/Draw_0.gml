//draw awesome objects!!! yay!!!!!
//draw out of bounds border
var int32l=2147483647
draw_rect(-int32l, -int32l, room_width+int32l, int32l, c_black, 0.5)
draw_rect(-int32l, 0, int32l, room_height, c_black, 0.5)
draw_rect(-int32l, room_height, room_width+int32l*2, int32l, c_black, 0.5)
draw_rect(room_width, 0, int32l, room_height, c_black, 0.5)
//border
draw_rect(-1, -1, room_width+2, room_height+2, c_white, 0.75, true)
draw_rect(-2, -2, room_width+4, room_height+4, c_white, 0.75, true)

for (var i = 0; i < ds_list_size(object_layer_map); ++i) {
	var obj = ds_list_find_value(object_layer_map, i)
	
	var sprite = ds_map_find_value(obj_data,obj[0])
	
	//for some reason applying camera x and camera y to the second rectangle just doesnt work for some reason 
	
	if !rectangle_in_rectangle(obj[1]*16, obj[2]*16, (obj[1]*16)+(sprite[3]*obj[3])-camera_get_view_x(view_camera[0]),(obj[2]*16)+(sprite[4]*obj[4])-camera_get_view_y(view_camera[0]), 0, 0, camera_get_view_x(view_camera[0])+camera_get_view_width(view_camera[0]), camera_get_view_y(view_camera[0])+camera_get_view_height(view_camera[0]))
	continue;
	
    draw_sprite_ext(sprite[0], 0, (obj[1]*16)- sprite[1] + obj[8] , (obj[2]*16)- sprite[2] + obj[9], obj[3], obj[4], 0, c_white, selected_mode==OBJECT_MODE ? 1 : 0.33)
	if (obj[5]) && selected_tool == SELECT_TOOL {	
		draw_rect((obj[1]*16), (obj[2]*16), round(obj[6]/16)*16, round(obj[7]/16)*16, $ff5a2a, 0.5)
	}
	
	//draw eraser rectangle
	if selected_tool == ERASE_TOOL {
		var pos = 0
		pos.x = (obj[1]*16) 
		pos.y = (obj[2]*16)
		draw_rect(pos.x, pos.y, 16, 16, c_white, 1, true)
	}
	if global.debug draw_text((obj[1]*16), (obj[2]*16), $"{obj[1]} {obj[2]}")
}