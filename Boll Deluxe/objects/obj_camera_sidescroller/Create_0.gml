stanncam_init(RESOLUTION_X, RESOLUTION_Y, RESOLUTION_X, RESOLUTION_Y);

cam1 = new stanncam(oPlayer.x, oPlayer.y, RESOLUTION_X, RESOLUTION_Y);
cam1.follow = oPlayer;
cam1.room_constrain = true;

speed_mode = 1;
zoom_mode = 1;

game_res = 2;
gui_hires = false;
gui_res = 0;

lookahead = false;

draw_zones = false;

surface = -1;


/*parralax_bg = function(_cam) {
	//the background is scaled up so it appears smooth when being parralaxed
	var _scalex = stanncam_get_res_scale_x();
	var _scaley = stanncam_get_res_scale_y();
	
	//the offset the camera is from the middle of the room
	var _offset_x = (-_cam.get_x() - _cam.x_frac) * _scalex;
	var _pos_x = -200 + _cam.x_frac;
	var _pos_y = 0 + _cam.y_frac;
	
	draw_sprite_ext_tiled(spr_underwater_layer00, 0, _pos_x + (_offset_x * 0.0), _pos_y, 2, 1, _scalex, _scaley);
	draw_sprite_ext_tiled(spr_underwater_layer01, 0, _pos_x + (_offset_x * 0.2), _pos_y, 2, 1, _scalex, _scaley);
	draw_sprite_ext_tiled(spr_underwater_layer02, 0, _pos_x + (_offset_x * 0.4), _pos_y, 2, 1, _scalex, _scaley);
	draw_sprite_ext_tiled(spr_underwater_layer03, 0, _pos_x + (_offset_x * 0.6), _pos_y, 2, 1, _scalex, _scaley);
	draw_sprite_ext_tiled(spr_underwater_layer04, 0, _pos_x + (_offset_x * 0.8), _pos_y, 2, 1, _scalex, _scaley);
	draw_sprite_ext_tiled(spr_underwater_layer05, 0, _pos_x + (_offset_x * 1.0), _pos_y, 2, 1, _scalex, _scaley);
}*/