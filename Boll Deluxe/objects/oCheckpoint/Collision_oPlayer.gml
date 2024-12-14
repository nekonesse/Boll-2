if (!hit) {
	hit = 1;
	
	instance_activate_object(oCheckpoint)
	event_user(0)
	
	global.checkpointX = x
	global.checkpointY = y
	global.checkpointDir = dir
	
	if (global.roomTimer < 10) { //assume you spawned at checkpoint if you hit it within 10 frames of the level starting
		sprite_index = spr_checkpoint_hit
		spinning = 1;
		exit;
	}
	
	VinylPlay(snd_checkpoint)
}

if (!spinning) {
	spinning = 1;
	var spd = abs(other.x - other.xprevious) //too many speed variables
	
	// AAARGH -moster
	
	if (spd <= 3) {
		image_speed = 1.5;
		spin_amount = 0;
	} else if (spd <= 6) {
		image_speed = 3.5;
		spin_amount = 1;
	} else {
		image_speed = 5.5;
		spin_amount = 2;
	}
	palette_speed = spin_amount + 1;
	
	
	prev_image_index = floor(image_index)
}