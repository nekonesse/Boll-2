/// @description Animation
if (in_shell) {
	if (in_shell > (shell_time/2.5)) {
		sprite_index = spr_koopashellspin_r; 
		image_speed = 1;
		if (hsp==0) {
			image_speed = 0;
			image_index = 0;
		}
	} else {
		sprite_index = spr_koopashellwake_r;
		image_speed = 1;
	}
} else {
	if (turning) {
		sprite_index = spr_koopaturn_r;
	} else if (getup_timer) {
		sprite_index = spr_koopapopout_r;
		image_speed = 1;
	} else {
		if (grounded) {
			sprite_index = spr_koopawalk_r;
		} else {
			sprite_index = spr_koopafall_r;
		}
		image_speed = 1;
	}
}