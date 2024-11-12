if !global.debug exit;
draw_set_alpha(0.25)
draw_rectangle_color(0,0,64,256,c_black,c_black,c_black,c_black,false)
draw_set_alpha(1)

draw_set_font(smallF)
var ext = ""
if (room == rEditor) && instance_exists(oJADEController) {
ext=$"EDITOR OBJECTS: {ds_list_size(oJADEController.object_layer_map)}"
}
draw_text(2,2,$"FPS: {fps}\n\nUNCAPPED FPS: {fps_real}\n\nROOM SPEED: {room_speed}\n\nCAM: {camera_get_view_x(view_camera[0])},{camera_get_view_y(view_camera[0])}\n\nROOM: {room_width},{room_height}\n\nINSTANCE COUNT:{instance_count}\n\n{ext}")
if instance_exists(oPlayer) {
	draw_text(2,64,$"Player Stuff: {oPlayer.x},{oPlayer.y}\n\nSprite: {oPlayer.spriteEvent}\n\nHsp: {oPlayer.hsp}\n\nVsp: {oPlayer.vsp}\n\nGsp: {oPlayer.gsp}\n\nSlopeAngle: {oPlayer.colangle}\n\nSlope: {oPlayer.colslope}\n\nXsc: {oPlayer.xsc}\n\nMove Var: {oPlayer.move}\n\nno_move: {oPlayer.no_move}\n\npiped: {oPlayer.piped}\n\ndown: {oPlayer.down}\n\nsteep: {oPlayer.steep_slope}\n\ndepth: {oPlayer.depth}\n\nCam Zoom: {oPlayer.my_camera.zoom}\n\nPolygon timer: {oPlayer.polyfloor[1]}\n\nElectrocuted: {oPlayer.electrocuted}\n\nElecocution Timer: {oPlayer.electrocution_timer}\n\nMove: {oPlayer.move}")
}
draw_set_font(basicPlaceholderF)