//draw awesome objects!!! yay!!!!!
//draw out of bounds border

var int32l=2147483647
draw_rect(-int32l, -int32l, room_width+int32l*2, int32l, c_black, 0.5)
draw_rect(-int32l, 0, int32l, room_height, c_black, 0.5)
draw_rect(-int32l, room_height, room_width+int32l*2, int32l, c_black, 0.5)
draw_rect(room_width, 0, int32l, room_height, c_black, 0.5)
//border
draw_rect(-1, -1, room_width+2, room_height+2, c_white, 0.75, true)
draw_rect(-2, -2, room_width+4, room_height+4, c_white, 0.75, true)

var i=0;
repeat(ds_list_size(object_layer_map[selected_region])) {
	var obj=object_layer_map[selected_region][| i]
	var data=obj_data[$ obj[0]]
	var alpha=1;
	if (selected_mode != OBJECT_MODE && selected_tool != NODE_TOOL) alpha=0.5;
	draw_sprite_ext(data.sprite,0,obj[1]+(data.xoff*obj[3]),obj[2]+(data.yoff*obj[4]),(obj[3]*data.sizex),(obj[4]*data.sizey),0,c_white,alpha);
	if (selected_mode == OBJECT_MODE) && array_get_index(selected_array, i)!=-1 {
		draw_rect(obj[1],obj[2],data.width*obj[3],data.height*obj[4],$ff5a2a,0.5)
	}
	i++;
}

var i=0;
repeat(ds_list_size(node_layer_map[selected_region])) {
	var obj=node_layer_map[selected_region][| i]
	var data=obj_data[$ obj[0]]
	var alpha=1;
	if (selected_mode != NODE_MODE || selected_tool == NODE_TOOL) alpha=0.5;
	draw_sprite_ext(data.sprite,0,obj[1]+(data.xoff*obj[3]),obj[2]+(data.yoff*obj[4]),(obj[3]*data.sizex),(obj[4]*data.sizey),0,c_white,alpha);
	if (selected_mode == NODE_MODE) && array_get_index(selected_array, i)!=-1 {
		draw_rect(obj[1],obj[2],data.width*obj[3],data.height*obj[4],$ff5a2a,0.5)
	}
	i++;
}