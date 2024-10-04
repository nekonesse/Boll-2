///@description Cursor
var cam_x = camera_get_view_x(view_camera[0])
var cam_y = camera_get_view_y(view_camera[0])
var cam_w = camera_get_view_width(view_camera[0])
var cam_h = camera_get_view_height(view_camera[0])

if (not_on_gui) {
	switch (selected_tool) {
		case BRUSH_TOOL:
		switch (selected_mode) {
			case OBJECT_MODE:
			is_string(selected_obj) {
				var arr=ds_map_find_value(obj_data,selected_obj)
				var xoff=arr[1]
				var yoff=arr[2]
				draw_sprite_ext(arr[0],0,gridx*16-xoff-cam_x,gridy*16-yoff-cam_y,1,1,0,c_white,0.25)
			}
			break;
			case TILE_MODE:
				var _tile = tilemap_get_tileset(tilemap)
				var _data = tilemap_get(tilemap, 0,0)
				_data = tile_set_index(_data, current_tile_id)
				draw_set_alpha(0.25)
				draw_tile(_tile, _data, 0, gridx*16-cam_x, gridy*16-cam_y)
				draw_set_alpha(1)
			break;
		}
		break;
		case ERASE_TOOL:
		case PICKER_TOOL:
			draw_sprite(spr_JADEerase_overlay,0,gridx*16-cam_x,gridy*16-cam_y)
		break;
	}
}

if global.debug {
	draw_set_font(smallF)
	draw_text(curs_x,curs_y+16,$"{gridx} {gridy}\n\n{view_grab}\n\n{cam_x} {cam_y}\n\n{selection_box}\n\n{cam_w} {cam_h}\n\n{zoom_level}\n\n{not_on_gui}")
}

draw_sprite(spr_JADEcursor,0,curs_x,curs_y)
draw_sprite_ext(spr_JADEicons,selected_tool-1,curs_x+4,curs_y+4,0.5,0.5,0,c_white,1)