///@description Cursor
if (not_on_gui) {
	switch (selected_tool) {
		case BRUSH_TOOL:
		is_string(selected_obj) {
			var arr=ds_map_find_value(obj_data,selected_obj)
			var xoff=arr[2]
			var yoff=arr[3]
			draw_sprite_ext(arr[0],0,gridx*16-xoff,gridy*16-yoff,1,1,0,c_white,0.25)
		}
		break;
		case ERASE_TOOL:
		case PICKER_TOOL:
		draw_sprite(spr_JADEerase_overlay,0,gridx*16,gridy*16)
		break;
	}
}

if global.debug {
	draw_set_font(smallF)
	draw_text(curs_x,curs_y+16,string(gridx)+" "+string(gridy))
	draw_rectangle_color(gridx*16,gridy*16,gridx*16+15,gridy*16+15,c_red,c_red,c_red,c_red,true)
}

draw_sprite(spr_JADEcursor,0,curs_x,curs_y)
draw_sprite_ext(spr_JADEicons,selected_tool-1,curs_x+4,curs_y+4,0.5,0.5,0,c_white,1)