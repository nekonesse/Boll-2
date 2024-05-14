event_inherited()
dy=0
hit=false;
image_speed=0;
spd=0
hit=0;
going=false;
dummyTimerReset = 6; //time (in frames) to hold on final "up" pos
dummyTimer = dummyTimerReset;
bumpMax = 6; //highest "up" pos for bumping
hitNegative = false; //used for the bumping "overshoot" anim end-bounce
no_hit = false;

image_normal = sprite_index
image_hit = sprite_index
image_exausted = sprite_index

blockHit = new Signal();
blockFinished = new Signal();

blockHit.Connect( self, function(hit_p, obj) {
    
	hit = hit_p;
	dy = -1 * hit;
	obj.vsp = 2;
	going = true;
	
	sprite_index = image_hit

});