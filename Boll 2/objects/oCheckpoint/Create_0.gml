hit = 0;
spinning = 0;
palette_frame = 0;
palette_speed = 1;
spin_amount = 0;
dir = 0;
flag_scale = 1;
spin_speed = 0;
flag_index = 0;
flag_sprite = spr_checkpoint_flag;
spin_dir = 0;
depth=15;

activate = new Signal();
reset = new Signal();

activate.Connect(self, function(hit_p) {
	if !(hit) {
		hit = 1;
	
		event_user(0);
	
		global.checkpointX = x;
		global.checkpointY = y+32;
		global.checkpointDir = dir
	
		if (global.roomTimer < 10) { //assume you spawned at checkpoint if you hit it within 10 frames of the level starting
			flag_index = 1;
			spinning = 1;
			exit;
		}
	
		VinylPlay(snd_checkpoint)
		a11y_speak("Checkpoint.");
	}

	if !(spinning) {
		spinning = 1;
		var spd = abs(hit_p.hsp) //too many speed variables
	
		if (spd <= 3) {
			spin_speed = 1.5;
			spin_amount = 0;
		} else if (spd <= 6) {
			spin_speed = 3.5;
			spin_amount = 1;
		} else {
			spin_speed = 5.5;
			spin_amount = 2;
		}
		palette_speed = spin_amount + 1;
	}
});

reset.Connect(self, function() {
	hit = 0;
	spinning = 0;
	palette_frame = 0;
	palette_speed = 1;
	spin_amount = 0;
	dir = 0;
	flag_scale = 1;
	spin_speed = 0;
	flag_index = 0;
	spin_dir = 0;
});