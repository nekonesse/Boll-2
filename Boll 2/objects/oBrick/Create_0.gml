// Inherit the parent event
event_inherited();

blockHit.Connect( self, function(hit_p, obj) {
 
	hit = hit_p;
	dy = -1 * hit;
	going = true;
	var j = noone;
	
	if (object_is_ancestor(obj.object_index,oEnemy)) || (variable_instance_exists(obj,"can_break_bricks") && bool(variable_instance_get(obj,"can_break_bricks"))) {
		brickBreak();
	}
});

brickBreak = function() {
	VinylPlay(snd_blockbreak)
	instance_destroy();
	j = instance_create(x-4,y+4,pDestruction) with(j){image_index=0 hspeed=-1 vspeed=-2} //bottom left
	j = instance_create(x-4,y-4,pDestruction) with(j){image_index=0 hspeed=1 vspeed=-2} //bottom right
	j = instance_create(x+4,y+4,pDestruction) with(j){image_index=0 hspeed=-1 vspeed=-4} //top left
	j = instance_create(x+4,y-4,pDestruction) with(j){image_index=0 hspeed=1 vspeed=-4} //top right
}