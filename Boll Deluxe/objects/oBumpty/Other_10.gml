///@description Animation Controller
if (bumped) {
	sprite_index = spr_bumptybump
} else if (sliding) {
	image_speed = abs(gsp/3)
	sprite_index = spr_bumptyslide;
} else {
	switch(behavior_mode) {
		case bumptyBehaviors.wander_mode:
			if (looking_around) {
				sprite_index = spr_bumptylooking;
			} else if (turning) {
				sprite_index = spr_bumptyturn;
			} else {
				sprite_index = spr_bumptywalk;
				image_speed = 1;
			}
		break;
		case bumptyBehaviors.flying_mode:
			if (turning) {
				sprite_index = spr_bumptyflyturn;
			} else {
				if (timer <= 40) {
					sprite_index = spr_bumptyhoverfall;
					image_speed = 1;
					if image_index>=image_number-1 {
						image_index=1;
					}
				} else {
					sprite_index = spr_bumptyfly
					image_speed = 1;
				}
			}
		break;
		case bumptyBehaviors.jumping_mode:
			if (looking_around) {
				image_speed = 2;
				sprite_index = spr_bumptylooking;
			} else if (jumped) {
				sprite_index = spr_bumptyjump;
				if image_index>=image_number-1 {
					image_index=image_number-1;
				}
			} else if (turning) {
				sprite_index = spr_bumptyturn;
			} else {
				image_speed = 1;
				sprite_index = spr_bumptywalk;
			}
		break;
	}
}