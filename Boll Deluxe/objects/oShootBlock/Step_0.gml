event_inherited();

if (hit != 0) && (!goDirection) {
	goDirection=hit
	no_collide=true;
}

if (goDirection != 0) {
	y += goDirection*3;
	image_index = ternary(goDirection, 1, 2);
	
	if place_meeting(x,y+goDirection,oCollider) {
		VinylPlay(snd_blockbreak)
		instance_destroy();
		var j=instance_create(x+4,y+12,pDestruction) with(j){image_index=0 hspeed=-1 vspeed=-2} //bottom left
		var j=instance_create(x+12,y+12,pDestruction) with(j){image_index=0 hspeed=1 vspeed=-2} //bottom right
		var j=instance_create(x+4,y+4,pDestruction) with(j){image_index=0 hspeed=-1 vspeed=-4} //top left
		var j=instance_create(x+12,y+4,pDestruction) with(j){image_index=0 hspeed=1 vspeed=-4} //top right
	}
}