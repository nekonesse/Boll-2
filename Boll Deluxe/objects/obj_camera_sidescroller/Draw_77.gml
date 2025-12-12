var _width = global.res_w;
var _height = global.res_h;

//the parralax drawing is scaled down again
var _scalex = 1 / stanncam_get_res_scale_x();
var _scaley = 1 / stanncam_get_res_scale_y();

with(oGameManager) {
	event_user(0);
}
cam1.draw(0, 0);