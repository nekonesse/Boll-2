var region_width = regions[selected_region].get_width();
var region_height = regions[selected_region].get_height();

//draw out of bounds border
var int32l=2147483647
draw_rect(-int32l, -int32l, region_width+int32l*2, int32l, c_black, 0.5)
draw_rect(-int32l, 0, int32l, region_height, c_black, 0.5)
draw_rect(-int32l, region_height, region_width+int32l*2, int32l, c_black, 0.5)
draw_rect(region_width, 0, int32l, region_height, c_black, 0.5)
//border
draw_rect(-1, -1, region_width+2, region_height+2, c_white, 0.75, true)
draw_rect(-2, -2, region_width+4, region_height+4, c_white, 0.75, true)

if (objects_visible || selected_mode == OBJECT_MODE) {
	var i=0;
	repeat(ds_list_size(object_layer_map)) {
		var obj=object_layer_map[| i]
		var data = obj_data[$ obj[0]]
		var alpha=1;
		if (selected_mode != OBJECT_MODE && selected_tool != NODE_TOOL) alpha=0.5;
		JADE_draw_object(obj, alpha)
		if (selected_mode == OBJECT_MODE) && array_get_index(selected_array, i)!=-1 {
			draw_rect(obj[1],obj[2],data.width*obj[3],data.height*obj[4],$ff5a2a,0.5)
		}
		if (selected_tool == NODE_TOOL) && (drawing_node == -1) && point_in_rectangle(mouse_x,mouse_y,obj[1],obj[2],obj[1]+data.width*obj[3],obj[2]+data.height*obj[4]) {
			draw_rect(obj[1],obj[2],data.width*obj[3],data.height*obj[4],$54b9fb,1,true)
		}
		i++;
	}
	var alpha=1;
	if (selected_mode != OBJECT_MODE && selected_tool != NODE_TOOL) alpha=0.5;
	draw_sprite_ext(spr_spawner, 1, testpoint_x + 8, testpoint_y + 8, 1, 1, 0, c_white, alpha);
	draw_sprite_ext(spr_spawner, 0, spawnpoint_x + 8, spawnpoint_y + 8, 1, 1, 0, c_white, alpha);
}

if (gizmos_visible || selected_mode == NODE_MODE) {
	var i=0;
	repeat(ds_list_size(node_layer_map)) {
		var obj=node_layer_map[| i]
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
	var obj = object_layer_map[| drawing_node]
	
	var len = array_length(obj[10])
	
	draw_set_font(global.omiFont);
	draw_set_halign(fa_center);
	draw_set_valign(fa_center);
	var rounded_x = (ceil((gridx*current_grid_size-8)/current_grid_size)*current_grid_size)+8;
	var rounded_y = (ceil((gridy*current_grid_size-8)/current_grid_size)*current_grid_size)+8;
	
	draw_circle_color(obj[1]+8,obj[2]+8,4,$505050,$505050,false);
	draw_circle_color(obj[1]+8,obj[2]+8,3,$54b9fb,$54b9fb,false);
	
	if (len) && !(changed_grid_size) && (keyboard_check(vk_shift)) {
		var nodeend = obj[10][len-1]
		if (nodeend[3]==0) {
			var dist = point_distance(nodeend[0],nodeend[1],rounded_x,rounded_y)
			var angle = point_direction(nodeend[0],nodeend[1],rounded_x,rounded_y)
			draw_sprite_ext(spr_1x1,0,nodeend[0],nodeend[1],dist,2,angle,$54b9fb,0.5)
		} else {
			DrawQuadraticCurve(nodeend[0],nodeend[1],rounded_x,rounded_y,nodeend[3]/22.5,max(8,floor(abs(nodeend[3])/2)),$54b9fb,0.5)
		}
		
		if (obj[11][2] == "continue") && (len>1) {
			var nodestart = obj[10][0]
			var dist = point_distance(rounded_x,rounded_y,nodestart[0],nodestart[1])
			var angle = point_direction(rounded_x,rounded_y,nodestart[0],nodestart[1])
			draw_sprite_ext(spr_1x1,0,rounded_x,rounded_y,dist,2,angle,$54b9fb,0.5)
		}
	}
	
	var i=0;
	repeat (len) {
		var node = obj[10][i]
		if (i<len-1) || (i==len-1 && (len>2 || (node[3]!=obj[10][0][3])) && obj[11][2] == "continue") {
			var node2;
			if (i<len-1) {
				node2=obj[10][i+1];
			} else {
				node2=obj[10][0];
			}
			if (node[3]==0) {
				var dist = point_distance(node[0],node[1],node2[0],node2[1])
				var angle = point_direction(node[0],node[1],node2[0],node2[1])
				draw_sprite_ext(spr_1x1,0,node[0],node[1],dist,2,angle,$54b9fb,1)
			} else {
				DrawQuadraticCurve(node[0],node[1],node2[0],node2[1],node[3]/22.5,max(8,floor(abs(node[3])/2)),$54b9fb,1)
			}
		}
		i++;
	}
	
	i=0;
	repeat (len) {
		var node = obj[10][i]
		draw_circle_color(node[0],node[1],6,$505050,$505050,false);
		draw_circle_color(node[0],node[1],5,$54b9fb,$54b9fb,false);
		draw_text(node[0],node[1],i);
		if (selected_node == i) || point_in_rectangle(mouse_x,mouse_y,node[0]-8,node[1]-8,node[0]+8,node[1]+8) {
			draw_circle_color(node[0],node[1],8,$54b9fb,$54b9fb,true);
		}
		i++;
	}
	
	if !(changed_grid_size) && (vk_shift) {
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