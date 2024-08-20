if !global.debug exit;
draw_set_alpha(0.25)
draw_rectangle_color(0,0,64,256,c_black,c_black,c_black,c_black,false)
draw_set_alpha(1)

draw_set_font(smallF)
var ext = ""
if (room == rEditor) && instance_exists(oJADEController) {
ext=$"EDITOR OBJECTS: {ds_list_size(oJADEController.object_layer_map)}"
}
draw_text(2,2,$"FPS: {fps}\n\nUNCAPPED FPS: {fps_real}\n\nROOM SPEED: {room_speed}\n\nCAMX: {global.camera_x}\n\nINSTANCE COUNT:{instance_count}\n\n{ext}")
if instance_exists(oPlayer) {
	draw_text(2,64,$"Player Stuff:\n\nSprite: {oPlayer.sprite}\n\nHsp: {oPlayer.hsp}\n\nVsp: {oPlayer.vsp}\n\nGsp: {oPlayer.gsp}\n\nSlopeAngle: {oPlayer.colangle}\n\nXsc: {oPlayer.xsc}\n\nMove Var: {oPlayer.move}\n\nno_move: {oPlayer.no_move}")
}
draw_set_font(basicPlaceholderF)