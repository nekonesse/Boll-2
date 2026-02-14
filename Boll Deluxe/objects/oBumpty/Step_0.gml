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
		y=ystart+wave_val(-8,8,1.5);
		
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
			timer = max(timer-1,0);
			if !(timer) && (grounded) {
				switch(state) {
					case 0:
						timer = 8;
						vsp = -4; //jump
						constantspd = 2.5;
						jumped = true;
						grounded = false;
						state++;
					break;
					case 1:
						sliding = true;
						walker = false;
					break;
					case 2:
						overridexsc = true;
						xsc=-xsc;
						_direction=-_direction;
						hsp = 0;
						constantspd = 0;
						vsp = -4; //jump again
						jumped = true;
						grounded = false;
						timer = 0;
						state++;
					break;
					case 3:
						overridexsc = false;
						timer=20;
						looking_around = true;
						state++;
					break;
					case 4:
						looking_around = false;
						var player = nearestplayer();
						if (_direction != sign(player.x-x)) {
							enemyTurnAround.Emit();
						}
						timer=30;
						constantspd = 1.5;
						state=0;
					break;
				}
			}
		}
	break;
}

if (sliding) {
	walker = false;
	no_turn_anim = true;
	no_slope_influence = true;
	if (grounded) {
		hsp = approach_val(hsp, 0, 0.01);
		if (abs(hsp) <= 0.2) {
			no_turn_anim = false;
			no_slope_influence = false;
			walker = true;
			if (behavior_mode == bumptyBehaviors.jumping_mode) {
				state++;
				constantspd = 1.5;
				timer=0;
			}
			sliding = false;
		}
	}
}

if (grounded) {
	bumped = false;
	jumped = false;
	gsp = hsp
}