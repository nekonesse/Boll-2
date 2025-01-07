if !on_screen(32,32) && !origin_on_screen(xstart,ystart,32,32) {
	x = xstart
	y = ystart
} else if on_screen(32,32) {
	instance_activate_region(x-activation_region_width, y-activation_region_width, activation_region_width*2, activation_region_height*2, true)
}

if (parent_pipe == noone) {
	player_collision();
	x+=hsp
	y+=vsp
	exit
}

if floor(y)==parent_pipe.y vsp=0

if (vsp==0) {
	timer=max(0,timer-1)

	if !(timer) {
		if !(collision_rectangle(x-24,0,x+24,room_height,oPlayer,false,true)) {
			vsp=-5
			y-=1
			timer=90;
		}
	}
} else timer=90;

if round(vsp) < 0 {
	sprite_index=fly_sprite
	vsp=lerp(vsp,0,0.04)
} else	{
	if sprite_index!=fall_sprite image_index*=2
	sprite_index=fall_sprite
	vsp=lerp(vsp,0.75,0.025)
}

y=min(y,parent_pipe.y)

y+=vsp
x=parent_pipe.x