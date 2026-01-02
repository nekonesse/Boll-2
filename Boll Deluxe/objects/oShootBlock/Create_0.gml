// Inherit the parent event
event_inherited();
can_break_bricks = true;

bumpMax = 5; //highest "up" pos for bumping

goDirection = 0; //direction of shoot

blockHit.Connect(self, function() {
	image_index = ternary(hit, 1, 2);
	no_collide=true;
	no_path_follow=true;
});

blockBumpFinished.Connect(self, function(){
	if (hit != 0) && (!goDirection) {
		VinylPlay(snd_shootblockshoot);
		goDirection=hit
		no_collide=true;
		no_path_follow=true;
		hspeed=0;
		vspeed=0;
		gravity=0;
	}
});