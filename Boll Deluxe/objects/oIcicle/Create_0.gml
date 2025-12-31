// Inherit the parent event
event_inherited();

slippery = true
my_friction = 0.5;
semi = true;
can_fall = true;

hsp = 0;
vsp = 0;

fall = false;
fallgo = false;

visible = 1;

breakIcicle = function() {
	var j=noone
	j = instance_create(x+4,y+24,pDestruction) with(j){image_index=10 hspeed=-1 vspeed=-2} //bottom left
	j = instance_create(x+4,y+20,pDestruction) with(j){image_index=10 hspeed=1 vspeed=-2} //bottom right
	j = instance_create(x+8,y+24,pDestruction) with(j){image_index=10 hspeed=-1 vspeed=-4} //top left
	j = instance_create(x+8,y+20,pDestruction) with(j){image_index=10 hspeed=1 vspeed=-4} //top right
	VinylPlay(snd_iceshatter)
	y=ystart
	visible=0;
	respawn_timer=120;
	no_collide = true;
	fallgo=false;
	fall=false;
	vsp=0;
	alarm[0]=-1;
}