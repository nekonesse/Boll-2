var ext = "";

if (global.debug)
{
	draw_set_alpha(0.35)
	draw_rectangle_color(0,0,102,256,c_black,c_black,c_black,c_black,false)
	draw_set_alpha(1)

	draw_set_font(global.omiFont)

	if (room == rEditor) && instance_exists(oJADEController) {
		ext=$"EDITOR OBJECTS: {ds_list_size(oJADEController.object_layer_map)+ds_list_size(oJADEController.node_layer_map)}\nEDITOR TILES: {ds_list_size(oJADEController.tile_layer_map[oJADEController.selected_tile_layer])}"
	}

	var fps_color = c_white;

	// adopt the SRB2 method of coloring the FPS depending on if we're meeting the target
	if (fps_real < int64(FPS_TARGET * 0.625))
	{
		// severely below target
		fps_color = c_red;
	}
	else if (fps_real < (FPS_TARGET))
	{
		// below target
		fps_color = c_yellow;
	}
	else if (fps_real < (FPS_TARGET * 2))
	{
		// meeting target
		fps_color = #D8FFD8;	
	}

	draw_text_color(2,2,$"\nUNCAPPED FPS: {fps_real}/{FPS_TARGET}",fps_color,fps_color,fps_color,fps_color,1);
	draw_text(2,2,$"FPS: {fps}\n\nROOM SPEED: {room_speed}\nCAM: {camera_get_view_x(view_camera[0])},{camera_get_view_y(view_camera[0])}\nROOM: {room_width},{room_height}\nINSTANCE COUNT:{instance_count}\n{ext}")
	draw_set_font(basicPlaceholderF)
}
else if (global.fps_display)
{
	draw_set_font(global.omiFont);
	
	var fps_color = c_white;

	// adopt the SRB2 method of coloring the FPS depending on if we're meeting the target
	if (fps_real < int64(FPS_TARGET * 0.625))
	{
		// severely below target
		fps_color = c_red;
	}
	else if (fps_real < (FPS_TARGET))
	{
		// below target
		fps_color = c_yellow;
	}
	else if (fps_real < (FPS_TARGET * 2))
	{
		// meeting target
		fps_color = #D8FFD8;	
	}
	
	draw_set_alpha(0.35)
	draw_rectangle_color(0,0,102,32,c_black,c_black,c_black,c_black,false);
	draw_set_alpha(1)
	
	draw_text_color(2,2,$"UNCAPPED FPS: {fps_real}/{FPS_TARGET}",fps_color,fps_color,fps_color,fps_color,1);
	draw_text(2,2,$"\nFPS: {fps}\n"+ext);
}