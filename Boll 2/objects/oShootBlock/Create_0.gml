// Inherit the parent event
event_inherited();
can_break_bricks = true;

disguised = false;

image_speed = 0;

bumpMax = 5; //highest "up" pos for bumping

goDirection = 0; //direction of shoot

blockHit.Connect(self, function() {
	if !(disguised) {
		image_index = ternary(hit, 1, 2);
	} else {
		image_index = 1;
	}
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

onBreak = function() {
	if !(disguised) {
		with instance_create(x-4,y+4,pDestruction) {image_index=7 hspeed=-1 vspeed=-2} //bottom left
		with instance_create(x+4,y+4,pDestruction) {image_index=7 hspeed=1 vspeed=-2} //bottom right
		with instance_create(x-4,y-4,pDestruction) {image_index=7 hspeed=-1 vspeed=-4} //top left
		with instance_create(x+4,y-4,pDestruction) {image_index=7 hspeed=1 vspeed=-4} //top right
	} else {
		with instance_create(x-4,y+4,pDestruction) {image_index=9 hspeed=-1 vspeed=-2} //bottom left
		with instance_create(x+4,y+4,pDestruction) {image_index=9 hspeed=1 vspeed=-2} //bottom right
		with instance_create(x-4,y-4,pDestruction) {image_index=9 hspeed=-1 vspeed=-4} //top left
		with instance_create(x+4,y-4,pDestruction) {image_index=9 hspeed=1 vspeed=-4} //top right
	}

	if (VinylIsPlaying(snd_shootblockbreak)) {
		VinylStop(snd_shootblockbreak);
	}
	VinylPlay(snd_shootblockbreak);
}