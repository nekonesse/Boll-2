if (!hit) {
	hit = 1;
	
	global.checkpointX = x
	global.checkpointY = y
	
	if (global.roomTimer < 10) {
		sprite_index = spr_checkpoint_hit
		exit;
	}
	
	
	var spd = abs(other.x - other.xprevious) //too many speed variables
	
	//Increments in intervals of 0.75 because either its 12fps but designed for 16fps or better answer Spin Code sucks -moster
	
	if (spd <= 3) {
		image_speed = 0.75;	//1
	} else if (spd <= 6) {
		image_speed = 2.25;	//3
		spin_amount = 1;
	} else {
		image_speed = 4.5;	//6
		spin_amount = 3;
	}
}