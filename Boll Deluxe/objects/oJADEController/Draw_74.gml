cam_x = camera_get_view_x(camera)
cam_y = camera_get_view_y(camera)

//Draw selected background outline
if (selected_mode == DECO_MODE && deco_mode_type = "bg" && is_struct(selected_layer)) {
	var _sprite = selected_layer.sprite;
	var _width = sprite_get_width(_sprite)/zoom_level;
	var _height = sprite_get_height(_sprite)/zoom_level;
	var _x = (selected_layer.off_x-sprite_get_xoffset(_sprite)-cam_x)/zoom_level;
	var _y = (selected_layer.off_y-sprite_get_yoffset(_sprite)-cam_y)/zoom_level;
	draw_rect(_x,_y,_width,_height,$54b9fb,1,true)
}

if (not_on_gui) {
	if (selected_tool == SELECT_TOOL && selection_box) {
		//Selection Tool mass-select box
		selection_box_fr+=0.2
		var box_w = (mouse_x - selection_box_x)
		var box_h = (mouse_y - selection_box_y)
		draw_sprite_stretched(spr_JADEselection, floor(selection_box_fr), floor(floor(selection_box_x)+min(box_w, 0)-cam_x)/zoom_level, floor(floor(selection_box_y)+min(box_h, 0)-cam_y)/zoom_level, floor(abs(box_w))/zoom_level, floor(abs(box_h))/zoom_level)
	}

	if selected_tool == FILL_TOOL && tile_fill {
		var box_w = (floor((mouse_x - (tile_fill_last_x * 16)) / 16)) * (16/zoom_level)
		var box_h = (floor((mouse_y - (tile_fill_last_y * 16)) / 16)) * (16/zoom_level)
		draw_sprite_stretched(spr_JADEselection, floor(selection_box_fr), floor((floor(tile_fill_last_x * 16-cam_x)/zoom_level)+min(box_w, 0)), floor((floor(tile_fill_last_y * 16-cam_y)/zoom_level)+min(box_h, 0)), floor(abs(box_w)), floor(abs(box_h)))
	}
}