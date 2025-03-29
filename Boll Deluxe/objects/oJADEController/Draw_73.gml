draw_set_font(global.omiFont)
draw_set_halign(fa_center)
draw_set_valign(fa_center)
var i=0;
repeat(ds_list_size(object_layer_map)) {
	var obj = ds_list_find_value(object_layer_map, i)
	
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
	i++;
}


draw_set_halign(fa_left)
draw_set_valign(fa_left)