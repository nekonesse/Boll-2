if _owner!=noone {
	instance_activate_region(x-16,y-16,32,32+(lineheight+4)*16, true)
}

if instance_exists(_owner) {
	x=lerp(x,_owner.x-8*_owner.xsc,0.1)+wave_val(-0.5,0.5,2)
	y=lerp(y,_owner.y-16-lineheight*16,0.1)
} else {
	vsp+=0.05;
	
	x+=hsp;
	y-=vsp;
	
	if !on_screen_xy(32,32+lineheight) {
		instance_destroy();
	}
}