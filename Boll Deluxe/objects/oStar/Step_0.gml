if (global.roomTimer & 7 == 0) {
	instance_create(x + random_range(-8, 8), y + random_range(-8, 8), pShine);
}

if !is_array(pathing) {
	if (going != 0) {
		image_index = 0
		y += 0.33 * (going)
		if !place_meeting(x, y-1 * going, parentblock) {
			going = 0
		}
	}

	if (going != 0) exit;

	if !grounded {
		vsp += grav
	} else {
		grav = 0.15;
		grounded = false;
		vsp = -4;
		if (hsp == 0) {
			hsp = 1;
		}
	}

	x += hsp;
	y += vsp;

	player_collision()
} else {
	node_path_movement();
}