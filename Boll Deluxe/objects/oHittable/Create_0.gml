event_inherited()
dy=0
hit=false;
image_speed=0;
spd=0
hit=0;
going=false;
dummyTimerReset = 4; //time (in frames) to hold on final "up" pos
dummyTimer = dummyTimerReset;
bumpMax = 10; //highest "up" pos for bumping
hitNegative = false; //used for the bumping "overshoot" anim end-bounce
no_hit = false;
default_depth = 1;
amount=1; // the amount of items to hold
no_path_follow=false;
lose_amount=false;

image_normal = sprite_index
image_hit = sprite_index
image_exausted = sprite_index

blockHit = new Signal();
blockBumpFinished = new Signal();
blockFinished = new Signal();

blockHit.Connect( self, function(hit_p, obj) {

	show_debug_message("boing");
	hit = hit_p;
	dy = -1 * hit;
	going = true;
	
	if (amount) {
		sprite_index = image_hit
	}
});

pathing=-1;
pathprenum=0;
pathnum=1;
pathspd=2;
pathcanrev=false;
pathisrev=false;
pathfallen=false;
pathcanfall=false;
pathdraw=true;
pathstarted=true;