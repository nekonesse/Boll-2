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
					draw_sprite_ext(arr[0],0,gridx*16-xoff-cam_x,gridy*16-yoff-cam_y,arr[11],arr[12],0,c_white,0.25)
				}
			break;
			case TILE_MODE:
				var _tile = tilemap_get_tileset(tilemap)
				var _data = tilemap_get(tilemap, 0,0)
				var i=0;
				repeat(tile_sel_width+1) {
					var j=0;
					repeat(tile_sel_height+1) {
						_data = tile_set_index(_data, current_tile_id[i][j])
						draw_set_alpha(0.25)
						draw_tile(_tile, _data, 0, (gridx + i)*16-cam_x, (gridy + j)*16-cam_y)
						j++;
					}
					i++;
				} 
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

if (selected_mode == TILE_MODE) {
	draw_sprite_ext(spr_JADEShowSelLayer,selected_tile_layer,0,RESOLUTION_Y,1,1,0,#FFFFFF,ui_opacity)
}

if global.debug {
	draw_text(curs_x,curs_y+16,$"{gridx} {gridy}\n\n{view_grab}\n\n{cam_x} {cam_y}\n\n{selection_box}\n\n{cam_w} {cam_h}\n\n{zoom_level}\n\n{not_on_gui}")
}

draw_sprite(spr_JADEcursor,0,curs_x,curs_y)
draw_sprite_ext(spr_JADEicons,selected_tool-1,curs_x+4,curs_y+4,0.5,0.5,0,c_white,1)