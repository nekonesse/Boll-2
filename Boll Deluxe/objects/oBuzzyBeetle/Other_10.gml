/// @description Animation
if (in_shell) {
	if (in_shell > (shell_time / 2.5)) {
		sprite_index = spr_buzzyshell; 
		if !(ceiling_falling) {
			image_speed = abs(hsp);
			if (!shell_move) image_index = 0;
		} else {
			image_speed = 3.5;
		}
	} else {
		sprite_index = spr_buzzyshell_wake;
		image_speed = 1;
	}
} else {
	ysc = ternary(onceiling,-1,1);
	
	if !(turning) {
		sprite_index = spr_buzzybeetle_walk;
	} else {
		sprite_index = spr_buzzybeetle_walk;
	}
	image_speed = 1;
}