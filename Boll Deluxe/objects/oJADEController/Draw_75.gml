///@description Cursor
var cam_x = camera_get_view_x(view_camera[0])
var cam_y = camera_get_view_y(view_camera[0])
var cam_w = camera_get_view_width(view_camera[0])
var cam_h = camera_get_view_height(view_camera[0])
var guiw=display_get_gui_width()
var guih=display_get_gui_height()

draw_set_font(global.omiFont)
if (not_on_gui) {
	switch (selected_tool) {
		case BRUSH_TOOL:
		switch (selected_mode) {
			case NODE_MODE:
			case OBJECT_MODE:
				if drawing_object==-1 {
					if is_string(selected_obj) {
						var arr=ds_map_find_value(obj_data,selected_obj)
						var xoff=arr[1]
						var yoff=arr[2]
						if arr[7] == selected_mode
						draw_sprite_ext(arr[0],0,gridx*16-xoff-cam_x,gridy*16-yoff-cam_y,arr[11],arr[12],0,c_white,0.25)
					}
				} else {
					if is_string(drawing_object) {
						var arr=ds_map_find_value(obj_data,drawing_object)
						var box_w, box_h;
						if arr[5]
						box_w = clamp(max(floor(gridx - drawing_object_x)+1, 1),1,11)
						else box_w = 1
						if arr[6]
						box_h = clamp(max(floor(gridy - drawing_object_y)+1, 1),1,11)
						else box_h = 1
						var xoff=(arr[1] = 0) ? 0 : arr[1] + (arr[3]/2) * box_w
						var yoff=(arr[2] = 0) ? 0 : arr[2] + (arr[4]/2) * box_h
						if arr[7] == selected_mode
						draw_sprite_ext(arr[0],0,drawing_object_x*16+xoff-arr[1]-cam_x,drawing_object_y*16+yoff-arr[2]-cam_y,((box_w*16)/arr[3])*arr[11],((box_h*16)/arr[4])*arr[12],0,c_white,0.25)
						draw_sprite(spr_JADE4scaler,3,(drawing_object_x*16)+(box_w*16)+xoff-arr[1]-cam_x,(drawing_object_y*16)+(box_h*16)+yoff-arr[2]-cam_y)
					}
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

if (selected_mode == TILE_MODE) {
	draw_sprite_ext(spr_JADEShowSelLayer,selected_tile_layer,0,guih,1,1,0,#FFFFFF,ui_opacity)
}

if global.debug {
	draw_text(curs_x,curs_y+16,$"{gridx} {gridy}\n\n{view_grab}\n\n{cam_x} {cam_y}\n\n{selection_box}\n\n{cam_w} {cam_h}\n\n{zoom_level}\n\n{not_on_gui}")
}

draw_sprite(spr_JADEcursor,0,curs_x,curs_y)
draw_sprite_ext(spr_JADEicons,selected_tool-1,curs_x+4,curs_y+4,0.5,0.5,0,c_white,1)