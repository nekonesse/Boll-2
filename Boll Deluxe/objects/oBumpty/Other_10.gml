///@description Animation Controller
switch(behavior_mode) {
	case bumptyBehaviors.wander_mode:
		if (looking_around) {
			sprite_index = spr_bumpty;
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
			} else {
				sprite_index = spr_bumptyfly
				image_speed = 1;
			}
		}
	break;
	case bumptyBehaviors.jumping_mode:
		if (looking_around) {
			sprite_index = spr_bumpty;
		} else if (turning) {
			sprite_index = spr_bumptyturn;
		} else {
			sprite_index = spr_bumptywalk;
			image_speed = 1;
		}
	break;
}

if (bumped) {
	sprite_index = spr_bumptybump
} else if (sliding) {
	image_speed = abs(gsp/3)
	sprite_index = spr_bumptyslide;
}