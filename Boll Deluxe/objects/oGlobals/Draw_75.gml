var ext = "";

if (global.debug)
{
	draw_set_alpha(0.35)
	draw_rectangle_color(0,0,102,256,c_black,c_black,c_black,c_black,false)
	draw_set_alpha(1)

	draw_set_font(global.omiFont)
	var morph_costs = get_morph_cost();

	if (room == rEditor) && instance_exists(oJADEController) {
		ext=""//$"EDITOR OBJECTS: {ds_list_size(oJADEController.object_layer_map[oJADEController.selected_region])+ds_list_size(oJADEController.node_layer_map[oJADEController.selected_region])}\nEDITOR TILES: {ds_list_size(oJADEController.tilemap)}"
	}
	else if (morph_costs[0] >= 0)
	{
		ext = $"MORPH COST: {morph_costs[0] / 1000}MS ({morph_costs[1]}%)";	
	}

	var fps_color = c_white;

	// adopt the SRB2 method of coloring the FPS depending on if we're meeting the target
	if (fps_real < (FPS_TARGET * 0.625))
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
	if instance_exists(oPlayer) {
		draw_text(2,72,$"Player Stuff: {oPlayer.x},{oPlayer.y}\nSprite: {oPlayer.spriteEvent}\nState: {oPlayer.state}\nHsp: {oPlayer.hsp}\nVsp: {oPlayer.vsp}\nGsp: {oPlayer.gsp}\nSlopeAngle: {oPlayer.colangle}\nSlope: {oPlayer.colslope}\nXsc: {oPlayer.xsc}\nMove Var: {oPlayer.move}\nno_move: {oPlayer.no_move}\npiped: {oPlayer.piped}\ndown: {oPlayer.down}\nsteep: {oPlayer.steep_slope}\ndepth: {oPlayer.depth}\nCam Zoom: {oPlayer.my_camera.zoom}\nPolygon timer: {oPlayer.polyfloor[1]}\nElectrocuted: {oPlayer.electrocuted}\nElecocution Timer: {oPlayer.electrocution_timer}\nMove: {oPlayer.move}\nFriction: {oPlayer.fric}\nFric mult: {oPlayer.friction_mult}\nInvincibility Type: {oPlayer.invincible_type}\nInvincibility Timer: {oPlayer.invincible_timer}")
	}
	draw_set_font(basicPlaceholderF)
}
else if (global.fps_display)
{
	draw_set_font(global.omiFont);
	
	var fps_color = c_white;
	var morph_costs = get_morph_cost();

	// adopt the SRB2 method of coloring the FPS depending on if we're meeting the target
	if (fps_real < (FPS_TARGET * 0.625))
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
	
	if (morph_costs[0] >= 0)
	{
		ext = $"MORPH COST: {morph_costs[0] / 1000}MS ({morph_costs[1]}%)";
	}
	
	draw_set_alpha(0.35)
	draw_rectangle_color(0,0,102,32,c_black,c_black,c_black,c_black,false);
	draw_set_alpha(1)
	
	draw_text_color(2,2,$"UNCAPPED FPS: {fps_real}/{FPS_TARGET}",fps_color,fps_color,fps_color,fps_color,1);
	draw_text(2,2,$"\nFPS: {fps}\n"+ext);
}