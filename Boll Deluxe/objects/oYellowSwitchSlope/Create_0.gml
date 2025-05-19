// Inherit the parent event
event_inherited();
ramp=false
hflip=false;

if hflip = true {
	image_xscale *= -1;
	x -= sprite_width + 0.5
}
switch_state=false;
slope_set_rise_run(self);
angle = floor(point_direction(x,y+sprite_height,x+(sprite_width*sign(image_xscale)),y))*sign(image_xscale)