if (physics_enabled) {
	if !grounded { 
		vsp=min(vsp+grav,6);
	}

	x += hsp
	y += vsp

	player_collision()
}

true_img_index += image_speed;
image_index = floor(true_img_index);

if (image_index >= 4) {
	true_img_index = 0;
	image_index = 0;
	image_speed = 0;
	alarm[0] = 150;
}