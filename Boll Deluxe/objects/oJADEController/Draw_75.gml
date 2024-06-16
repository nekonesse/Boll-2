///@description Cursor
if (not_on_gui) {
	switch (selected_tool) {
		case BRUSH_TOOL:
		switch (selected_mode) {
			case OBJECT_MODE:
			is_string(selected_obj) {
				var arr=ds_map_find_value(obj_data,selected_obj)
				var xoff=arr[2]
				var yoff=arr[3]
				draw_sprite_ext(arr[0],0,gridx*16-xoff-camera_get_view_x(view_camera[0]),gridy*16-yoff-camera_get_view_y(view_camera[0]),1,1,0,c_white,0.25)
			}
			break;
			case TILE_MODE:
				var _tile = tilemap_get_tileset(tilemap)
				var _data = tilemap_get(tilemap, 0,0)
				_data = tile_set_index(_data, current_tile_id)
				draw_set_alpha(0.25)
				draw_tile(_tile, _data, 0, gridx*16-camera_get_view_x(view_camera[0]), gridy*16-camera_get_view_y(view_camera[0]))
				draw_set_alpha(1)
			break;
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
	draw_text(curs_x,curs_y+16,$"{gridx} {gridy}\n\n{view_grab}\n\n{camera_get_view_x(view_camera[0])} {camera_get_view_y(view_camera[0])}")
	draw_rectangle_color(gridx*16,gridy*16,gridx*16+15,gridy*16+15,c_red,c_red,c_red,c_red,true)
}

draw_sprite(spr_JADEcursor,0,curs_x,curs_y)
draw_sprite_ext(spr_JADEicons,selected_tool-1,curs_x+4,curs_y+4,0.5,0.5,0,c_white,1)