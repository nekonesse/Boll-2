if (is_blue)
{
	draw_blue_swinging_platform(self);
}
else
{

	xx=targetx
	yy=targety
	
	var targetoverridex=targetx
	var targetoverridey=targety
	
	if (lock_x) targetoverridex=x
	
	draw_sprite(spr_swingplatchain,1,floor(targetoverridex),floor(targetoverridey))
	
	if (lock_y) {
		var i=1;
		repeat (chain_length) {
			xx=lerp(targetx,x,(i/chain_length))
			draw_sprite(spr_swingplatchain,0,floor(xx),floor(yy))
			i++;
		}
	} else if (lock_x) {
		var i=1;
		repeat (chain_length) {
			yy=lerp(targety,y,(i/chain_length))
			draw_sprite(spr_swingplatchain,0,floor(targetoverridex),floor(yy))
			i++;
		}
	} else {
		var i=1;
		repeat ((chain_length)) {
			xx=targetx+lengthdir_x(16*i,orbit_angle) yy=targety+lengthdir_y(16*i,orbit_angle)
			draw_sprite(spr_swingplatchain,0,floor(xx),floor(yy))
			i++;
		}
	}
		
	draw_sprite_ext(sprite_index,image_index,floor(x),floor(y),image_xscale,image_yscale,image_angle,c_white,1)
}