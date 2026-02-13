/// @description Animation
if (in_shell) {
	if (in_shell > (shell_time/2.5)) {
		sprite_index = spr_koopashellspin_y; 
		image_speed = 1;
		if (hsp==0) {
			image_speed = 0;
			image_index = 0;
		}
	} else {
		sprite_index = spr_koopashellwake_y;
		image_speed = 1;
	}
} else {
	if (turning) {
		sprite_index = spr_koopaturn_y;
	} else if (getup_timer) {
		sprite_index = spr_koopapopout_y;
		image_speed = 1;
	} else {
		sprite_index = spr_koopawalk_y;
		image_speed = 1;
	}
}