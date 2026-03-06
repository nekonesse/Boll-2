event_inherited();

lifespan = 600;
active = false;

pal = 0;

onPickup.Connect( self, function(carry_p) {
	active = true;
});

onBreak.Connect( self, function(carry_p) {
	VinylPlay(snd_blockbreak)
	j = instance_create(x-4,y+4,pDestruction) with(j){image_index=11 hspeed=-1 vspeed=-2} //bottom left
	j = instance_create(x-4,y-4,pDestruction) with(j){image_index=11 hspeed=1 vspeed=-2} //bottom right
	j = instance_create(x+4,y+4,pDestruction) with(j){image_index=11 hspeed=-1 vspeed=-4} //top left
	j = instance_create(x+4,y-4,pDestruction) with(j){image_index=11 hspeed=1 vspeed=-4} //top right
	instance_destroy();
});