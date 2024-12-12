if (!hit) {
	hit = 1;
	
	global.checkpointX = x
	global.checkpointY = y
	global.checkpointDir = dir
	
	if (global.roomTimer < 10) { //assume you spawned at checkpoint if you hit it within 10 frames of the level starting
		sprite_index = spr_checkpoint_hit
		exit;
	}
	
	
	var spd = abs(other.x - other.xprevious) //too many speed variables
	
	// AAARGH -moster
	
	if (spd <= 3) {
		image_speed = 1.25;
	} else if (spd <= 6) {
		image_speed = 3.25;
		spin_amount = 1;
	} else {
		image_speed = 5.25;
		spin_amount = 2;
	}
	
	prev_image_index = floor(image_index)
}