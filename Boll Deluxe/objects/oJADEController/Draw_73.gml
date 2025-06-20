draw_set_font(global.omiFont)
draw_set_halign(fa_center)
draw_set_valign(fa_center)
var i=0;
repeat(ds_list_size(object_layer_map)) {
	var obj = ds_list_find_value(object_layer_map, i)
	if (obj[5]) && selected_tool == SELECT_TOOL && selected_mode == OBJECT_MODE {
		draw_sprite(spr_JADE4scaler, 3, (obj[1]*16) + round(obj[6]/16)*16, (obj[2]*16) + round(obj[7]/16)*16)
	}
	
	var sprite = ds_map_find_value(obj_data,obj[0])
	var xoff = -sprite[1];
	var yoff = -sprite[2];
	if (sprite[9]) && (drawing_node==i) {
		draw_sprite(spr_JADEnode,1,(obj[1]*16)+(obj[6]-16)/2,(obj[2]*16)+(obj[7]-16)/2)
		if (array_length(obj[11]) > 0) {
			var j;
			j=0;
			repeat(array_length(obj[11])) {
				var arr=obj[11][j]
				if j>0 {
					var x2=obj[11][j-1][0]
					var y2=obj[11][j-1][1]
				} else {
					var x2=obj[11][0][0]
					var y2=obj[11][0][1]
				}
				draw_set_color($3d68cd)
				draw_line(x2+((obj[6]-16)/2)+(8-xoff),y2+((obj[7]-16)/2)+(8-yoff),arr[0]+((obj[6]-16)/2)+(8-xoff),arr[1]+((obj[7]-16)/2)+(8-yoff))
				draw_set_color(c_white)
				j++
			}
			if (not_on_gui) {
				draw_set_color($3d68cd)
				draw_line(draw_node_x+(8-xoff),draw_node_y+(8-yoff),(gridx*16)+8,(gridy*16)+8)
				draw_set_color(c_white)
			}
			j=0
			repeat(array_length(obj[11])) {
				var arr=obj[11][j]
				
				var over = point_in_rectangle(mouse_x, mouse_y, arr[0]+((obj[6]-16)/2)-xoff, arr[1]+((obj[7]-16)/2)-yoff, arr[0]+15+((obj[6]-16)/2)-xoff, arr[1]+15+((obj[7]-16)/2)-yoff)
				
				draw_sprite(spr_JADEnode,0,arr[0]+((obj[6]-16)/2)-xoff,arr[1]+((obj[7]-16)/2)-yoff)
				draw_set_color(c_black)
				draw_text((arr[0]+((obj[6]-16)/2)-xoff)+8,(arr[1]+((obj[7]-16)/2)-yoff)+8,j)
				draw_set_color(c_white)
				
				if (over){
					draw_circle_color((arr[0]+((obj[6]-16)/2)-xoff)+7,(arr[1]+((obj[7]-16)/2)-yoff)+7,8,$3d68cd,$3d68cd,true)
				}
				j++
			}
		}
		if (not_on_gui) {
			draw_sprite(spr_JADEnode,0,(gridx*16),(gridy*16))
		}
	}
	
	if (sprite[9]) && (drawing_rotator==i) {
		draw_sprite(spr_JADErotator,1,(obj[1]*16)+(obj[6]-16)/2,(obj[2]*16)+(obj[7]-16)/2)
		if (array_length(obj[13]) > 0) {
			var arr=obj[13]
			var x2=(obj[1]*16)-((obj[6]-16)/2)+xoff
			var y2=(obj[2]*16)-((obj[7]-16)/2)+yoff
			draw_set_color($88695a)
			draw_line(x2,y2,arr[0]+((obj[6]-16)/2)+(8-xoff),arr[1]+((obj[7]-16)/2)+(8-yoff))
			draw_set_color(c_white)
				
			var over = point_in_rectangle(mouse_x, mouse_y, arr[0]+((obj[6]-16)/2)-xoff, arr[1]+((obj[7]-16)/2)-yoff, arr[0]+15+((obj[6]-16)/2)-xoff, arr[1]+15+((obj[7]-16)/2)-yoff)
				
			draw_sprite(spr_JADErotator,0,arr[0]+((obj[6]-16)/2)-xoff,arr[1]+((obj[7]-16)/2)-yoff)
				
			if (over){
				draw_circle_color((arr[0]+((obj[6]-16)/2)-xoff)+7,(arr[1]+((obj[7]-16)/2)-yoff)+7,8,$88695a,$88695a,true)
			}
		} else if (not_on_gui) {
			draw_set_color($88695a)
			draw_line(draw_rotator_x+(8-xoff),draw_rotator_y+(8-yoff),(gridx*16)+8,(gridy*16)+8)
			draw_set_color(c_white)
			draw_sprite(spr_JADErotator,0,(gridx*16),(gridy*16))
		}
	}
	i++;
}

i=0;
repeat(ds_list_size(node_layer_map)) {
	var obj = ds_list_find_value(node_layer_map, i)
	if (obj[5]) && selected_tool == SELECT_TOOL && selected_mode == NODE_MODE {
		draw_sprite(spr_JADE4scaler, 3, (obj[1]*16) + round(obj[6]/16)*16, (obj[2]*16) + round(obj[7]/16)*16)
	}
	i++;
}

if selected_tool == FILL_TOOL && tile_fill && fill_circle {
	var start_x = tile_fill_last_x 
	var start_y = tile_fill_last_y 
	var size_x = (gridx - tile_fill_last_x)
	var size_y = (gridy - tile_fill_last_y) 
		
	if size_x < 0 {
		start_x = gridx
		size_x = abs(size_x)
	}
	if size_y < 0 {
		start_y = gridy
		size_y = abs(size_y)
	}
	draw_ellipse(tile_fill_last_x * 16,tile_fill_last_y * 16,gridx * 16, gridy * 16, true)
}
draw_set_halign(fa_left)
draw_set_valign(fa_left)