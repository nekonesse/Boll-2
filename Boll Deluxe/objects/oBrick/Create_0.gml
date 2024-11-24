// Inherit the parent event
event_inherited();

blockHit.Connect( self, function(hit_p, obj) {
 
	hit = hit_p;
	dy = -1 * hit;
	going = true;
	
	if (obj.can_break_bricks) {
		VinylPlay(snd_blockbreak)
		instance_destroy();
		var j=instance_create(x-4,y+4,pDestruction) with(j){image_index=0 hspeed=-1 vspeed=-2} //bottom left
		var j=instance_create(x-4,y-4,pDestruction) with(j){image_index=0 hspeed=1 vspeed=-2} //bottom right
		var j=instance_create(x+4,y+4,pDestruction) with(j){image_index=0 hspeed=-1 vspeed=-4} //top left
		var j=instance_create(x+4,y-4,pDestruction) with(j){image_index=0 hspeed=1 vspeed=-4} //top right
	}
});