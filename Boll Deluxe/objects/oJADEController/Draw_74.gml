

selection_box_fr+=0.2

//Selection Tool mass-select box
if selected_tool == SELECT_TOOL && selection_box {
	var box_w = (mouse_x - selection_box_x)/zoom_level
	var box_h = (mouse_y - selection_box_y)/zoom_level
	draw_sprite_stretched(spr_JADEselection, floor(selection_box_fr), floor((floor(selection_box_x-cam_x)/zoom_level)+min(box_w, 0)), floor((floor(selection_box_y-cam_y)/zoom_level)+min(box_h, 0)), floor(abs(box_w)), floor(abs(box_h)))
}

if selected_tool == FILL_TOOL && tile_fill && !fill_circle {
	var box_w = (floor((mouse_x - (tile_fill_last_x * 16)) / 16)) * (16/zoom_level)
	var box_h = (floor((mouse_y - (tile_fill_last_y * 16)) / 16)) * (16/zoom_level)
	draw_sprite_stretched(spr_JADEselection, floor(selection_box_fr), floor((floor(tile_fill_last_x * 16-cam_x)/zoom_level)+min(box_w, 0)), floor((floor(tile_fill_last_y * 16-cam_y)/zoom_level)+min(box_h, 0)), floor(abs(box_w)), floor(abs(box_h)))
}
