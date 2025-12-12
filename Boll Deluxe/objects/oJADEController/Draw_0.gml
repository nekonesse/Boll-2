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

if (objects_visible || selected_mode == OBJECT_MODE) {
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
		if (selected_tool == NODE_TOOL) && (drawing_node == -1) && point_in_rectangle(mouse_x,mouse_y,obj[1],obj[2],obj[1]+data.width*obj[3],obj[2]+data.height*obj[4]) {
			draw_rect(obj[1],obj[2],data.width*obj[3],data.height*obj[4],$54b9fb,1,true)
		}
		i++;
	}
}

if (gizmos_visible || selected_mode == NODE_MODE) {
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
}

if (drawing_node != -1) {
	var obj = object_layer_map[selected_region][| drawing_node]
	
	var len = array_length(obj[10])
	
	draw_set_font(global.omiFont);
	draw_set_halign(fa_center);
	draw_set_valign(fa_center);
	var rounded_x = (ceil((gridx*current_grid_size-8)/current_grid_size)*current_grid_size)+8;
	var rounded_y = (ceil((gridy*current_grid_size-8)/current_grid_size)*current_grid_size)+8;
	
	if (len) && !(changed_grid_size) {
		var nodeend = obj[10][len-1]
		var dist = point_distance(nodeend[0],nodeend[1],rounded_x,rounded_y)
		var angle = point_direction(nodeend[0],nodeend[1],rounded_x,rounded_y)
		draw_sprite_ext(spr_1x1,0,nodeend[0],nodeend[1],dist,2,angle,$54b9fb,0.5)
	}
	
	var i=0;
	repeat (len) {
		var node = obj[10][i]
		if (i<len-1) {
			var node2=obj[10][i+1]
			var dist = point_distance(node[0],node[1],node2[0],node2[1])
			var angle = point_direction(node[0],node[1],node2[0],node2[1])
			draw_sprite_ext(spr_1x1,0,node[0],node[1],dist,2,angle,$54b9fb,1)
		}
		i++;
	}
	
	i=0;
	repeat (len) {
		var node = obj[10][i]
		draw_circle_color(node[0],node[1],6,$505050,$505050,false);
		draw_circle_color(node[0],node[1],5,$54b9fb,$54b9fb,false);
		draw_text(node[0],node[1],i);
		i++;
	}
	
	if !(changed_grid_size) {
		draw_set_alpha(0.5)
		draw_circle_color(rounded_x,rounded_y,6,$505050,$505050,false);
		draw_circle_color(rounded_x,rounded_y,5,$54b9fb,$54b9fb,false);
		draw_set_alpha(1)
		draw_text(rounded_x,rounded_y,len);
	}
	
	draw_set_color(c_white);
	
	draw_set_halign(0);
	draw_set_valign(0);
}