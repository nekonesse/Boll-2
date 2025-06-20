///@description Cursor
var cam_x = camera_get_view_x(view_camera[0])
var cam_y = camera_get_view_y(view_camera[0])
var cam_w = camera_get_view_width(view_camera[0])
var cam_h = camera_get_view_height(view_camera[0])

draw_set_font(global.omiFont)
if (not_on_gui) {
	switch (selected_tool) {
		case BRUSH_TOOL:
		switch (selected_mode) {
			case NODE_MODE:
			case OBJECT_MODE:
				if is_string(selected_obj) {
					var arr=ds_map_find_value(obj_data,selected_obj)
					var xoff=arr[1]
					var yoff=arr[2]
					if arr[7] == selected_mode
					draw_sprite_ext(arr[0],0,(gridx*16-xoff-cam_x)/zoom_level,(gridy*16-yoff-cam_y)/zoom_level,arr[11]/zoom_level,arr[12]/zoom_level,0,c_white,0.25)
				}
			break;
			case TILE_MODE:
				var t_width = sprite_get_width(tilesets[$ current_tileset][0])
				var t_height = sprite_get_height(tilesets[$ current_tileset][0])
				var i=0;
				repeat(tile_sel_width+1) {
					var j=0;
					repeat(tile_sel_height+1) {
						var _data = current_tile_id[i][j]
						if _data != 0 {
							var t_x = ((_data mod (t_width / 16)) * 16)
							var t_y = (floor(_data / (t_width/16)) * 16)
							draw_sprite_part_ext(tilesets[$ current_tileset][0], 0, t_x, t_y, 16, 16, ((gridx+i)*16-cam_x)/zoom_level,((gridy+j)*16-cam_y)/zoom_level, 1/zoom_level, 1/zoom_level, c_white, 0.25)	
						}
						j++;
					}
					i++;
				}
			break;
		}
		break;
		case ERASE_TOOL:
		case PICKER_TOOL:
			draw_sprite(spr_JADEerase_overlay,0,gridx*(16*zoom_level)-cam_x,gridy*(16*zoom_level)-cam_y)
		break;

	}
}

if (selected_mode == TILE_MODE) {
	draw_sprite_ext(spr_JADEShowSelLayer,selected_tile_layer,0,RESOLUTION_Y,1,1,0,#FFFFFF,ui_opacity)
}

if global.debug {
	draw_text(curs_x,curs_y+16,$"{gridx} {gridy}\n\n{curs_x} {curs_y}\n\n{zoom_goto}")
}

draw_sprite(spr_JADEcursor,0,curs_x,curs_y)
draw_sprite_ext(spr_JADEicons,selected_tool-1,curs_x+4,curs_y+4,0.5,0.5,0,c_white,1)