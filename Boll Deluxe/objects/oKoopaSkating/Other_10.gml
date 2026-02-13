if (in_shell) {
	if (in_shell > (shell_time/2.5)) {
		sprite_index = spr_koopashellspin_skate; 
		image_speed = 1;
		if (hsp==0) {
			image_speed = 0;
			image_index = 0;
		}
	} else {
		sprite_index = spr_koopashellwake_skate;
		image_speed = 1;
	}
} else {
	if (turning) {
		sprite_index = spr_koopaturn_skate;
	} else if (getup_timer) {
		sprite_index = spr_koopapopout_skate;
		image_speed = 1;
	} else {
		sprite_index = spr_koopawalk_skate;
		image_speed = 1;
	}
}