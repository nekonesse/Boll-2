// Inherit the parent event
event_inherited();
image_speed=1;
do_bump=false;

blockHit.Connect( self, function(hit_p, obj) {
	
	hit = hit_p;
	do_bump=true;
	
	dy = -1 * hit;
	going = true;
});

bumpMax = 20; //highest "up" pos for bumping

blockBumpFinished.Connect( self, function() {
	do_bump=false;
});