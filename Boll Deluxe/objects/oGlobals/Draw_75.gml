if !global.debug exit;
draw_set_alpha(0.25)
draw_rectangle_color(0,0,64,256,c_black,c_black,c_black,c_black,false)
draw_set_alpha(1)

draw_set_font(smallF)
var morph_costs = get_morph_cost();

var ext = ""
if (room == rEditor) && instance_exists(oJADEController) {
ext=$"EDITOR OBJECTS: {ds_list_size(oJADEController.object_layer_map)}"
}
else if (morph_costs[0] >= 0)
{
	ext = $"MORPH COST: {morph_costs[0] / 1000}MS ({morph_costs[1]}%)";	
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

draw_text_color(2,2,$"\n\nUNCAPPED FPS: {fps_real}/{FPS_TARGET}",fps_color,fps_color,fps_color,fps_color,1);
draw_text(2,2,$"FPS: {fps}\n\n\n\nROOM SPEED: {room_speed}\n\nCAM: {camera_get_view_x(view_camera[0])},{camera_get_view_y(view_camera[0])}\n\nROOM: {room_width},{room_height}\n\nINSTANCE COUNT:{instance_count}\n\n{ext}")
if instance_exists(oPlayer) {
	draw_text(2,72,$"Player Stuff: {oPlayer.x},{oPlayer.y}\n\nSprite: {oPlayer.spriteEvent}\n\nHsp: {oPlayer.hsp}\n\nVsp: {oPlayer.vsp}\n\nGsp: {oPlayer.gsp}\n\nSlopeAngle: {oPlayer.colangle}\n\nSlope: {oPlayer.colslope}\n\nXsc: {oPlayer.xsc}\n\nMove Var: {oPlayer.move}\n\nno_move: {oPlayer.no_move}\n\npiped: {oPlayer.piped}\n\ndown: {oPlayer.down}\n\nsteep: {oPlayer.steep_slope}\n\ndepth: {oPlayer.depth}\n\nCam Zoom: {oPlayer.my_camera.zoom}\n\nPolygon timer: {oPlayer.polyfloor[1]}\n\nElectrocuted: {oPlayer.electrocuted}\n\nElecocution Timer: {oPlayer.electrocution_timer}\n\nMove: {oPlayer.move}")
}
draw_set_font(basicPlaceholderF)