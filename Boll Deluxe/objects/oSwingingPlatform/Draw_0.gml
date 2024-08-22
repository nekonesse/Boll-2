if (is_blue)
{
	draw_blue_swinging_platform(self);
}
else
{
	fr+=0.2
	if floor(fr) >= 3
	fr=0

	xx=targetx
	yy=targety

	repeat ((chain_length)+1) {
	    draw_sprite(spr_swingplatchain,0,floor(xx),floor(yy))
	    xx+=lengthdir_x(16,orbit_angle) yy+=lengthdir_y(16,orbit_angle)
	}
	draw_sprite(spr_swingplatchain,1,floor(targetx),floor(targety))

	draw_sprite_ext(sprite_index,image_index,floor(x),floor(y),image_xscale,image_yscale,image_angle,c_white,1)
}

