if (physics_enabled) && !(is_array(pathing) && array_length(pathing)) {
	if !grounded { 
		vsp=min(vsp+grav,6);
	}

	x += hsp
	y += vsp
	
	player_collision(true, false, (bbox_left-x),bbox_right-x,(bbox_top-y)+1,(bbox_bottom-y)-1);
}

true_img_index += image_speed;
image_index = floor(true_img_index);

if (image_index >= 4) {
	true_img_index = 0;
	image_index = 0;
	image_speed = 0;
	alarm[0] = 150;
}