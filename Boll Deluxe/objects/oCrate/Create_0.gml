// Inherit the parent event
event_inherited();
content="coin"
blockHit.Destroy();

blockHit.Connect( self, function(hit_p, obj) {
	event_user(1);
	
	VinylPlay(snd_blockbreak)
	var j = instance_create(x-4,y+4,pDestruction) with(j){image_index=3 hspeed=-1 vspeed=-2} //bottom left
	j = instance_create(x-4,y-4,pDestruction) with(j){image_index=3 hspeed=1 vspeed=-2} //bottom right
	j = instance_create(x+4,y+4,pDestruction) with(j){image_index=3 hspeed=-1 vspeed=-4} //top left
	j = instance_create(x+4,y-4,pDestruction) with(j){image_index=3 hspeed=1 vspeed=-4} //top right
	instance_destroy();
});