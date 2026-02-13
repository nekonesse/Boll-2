// Inherit the parent event
event_inherited();

switch(behavior_mode) {
	case bumptyBehaviors.wander_mode:
		if (grounded) {
			timer = max(timer-1,0);
			if !(timer) {
				if !(looking_around) {
					looking_around = true;
					constantspd = 0;
					timer = irandom_range(30,60);
				} else {
					looking_around = false;
					constantspd = 0.5;
					if chance(0.33) {
						enemyTurnAround.Emit();
					}
					timer = irandom_range(60,180);
				}
			}
		}
	break;
	case bumptyBehaviors.flying_mode:
		timer = max(timer-1,0);
		y=ystart+sin((timer-90)/8)*4;
		
		if !(turning) {
			xsc=-esign(hsp,xsc);
		} else {
			flipped = 0;
			turning=max(0,turning-1);
			xsc = -turnxsc;
			image_speed = 0;
			if !(turning) {
				image_speed = 1
			}
	
			image_index = (turning > 5)
		}
		
		if !(timer) {
			enemyTurnAround.Emit();
		}
		
		event_user(0);
		grav=0;
		vsp=0;
	break;
	case bumptyBehaviors.jumping_mode:
		if !(sliding) && !(bumped) {
			if (grounded) {
				timer = max(timer-1,0);
				if !(timer) {
					if !(looking_around) {
						if chance(0.66) {
							vsp = -4; //jump
							grounded = false;
						} else {
							looking_around = true //wait
							hsp = 0;
							slidetimer = irandom_range(60,120);
						}
					} else {
						looking_around = false;
					}
					timer = irandom_range(30,90);
				}
				
				directiontimer=max(directiontimer-1, 0);
				if !(directiontimer) {
					var player = nearestplayer();
					if (_direction != sign(player.x-x)) {
						enemyTurnAround.Emit();
					}
					directiontimer = irandom_range(20,40);
				}
			}
			
			if !(looking_around) {
				var speedcap = 1.5;
				if !(grounded) speedcap = 2.5;
				hsp = approach_val(hsp, speedcap*_direction, 0.1);				
				
				slidetimer = max(slidetimer-1,0);
				if !(slidetimer) {
					sliding = true;
					hsp = 3*_direction;
				}
			}
		}
	break;
}

if (sliding) {
	walker = false;
	hsp = approach_val(hsp, 0, 0.025);
	
	if (grounded) && (abs(hsp) <= 0.2) {
		if (behavior_mode == bumptyBehaviors.wander_mode) {
			walker = true;
		}
		sliding = false;
		slidetimer = irandom_range(60,120);
	}
}

if (grounded) {
	bumped = false;
	gsp = hsp
}