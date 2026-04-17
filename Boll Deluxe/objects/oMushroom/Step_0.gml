if !(is_array(pathing) && array_length(pathing)) {
	if (going!=0) {
		image_index=0
		y+=0.33*(going)
		if instance_exists(parentblock) {
			x+=parentblock.x_diff
			y+=parentblock.y_diff
			depth=oGameManager.piping_object_depth
			if !collision_rectangle(x-hit_sizex,y-hit_sizey-(1*going),x+hit_sizex,y+hit_sizey-(1*going),parentblock,false,false) {
				going=0
				depth=2;
				escapeItemBox.Emit();
			}
		}
	}

	if (going!=0) exit;

	if !grounded {
		vsp = min(vsp+grav,4)
	} else {
		vsp = 0
		hsp = approach_val(hsp,0,fric);
	}

	x += hsp;
	y += vsp;

	player_collision()

	if (hsp != 0) xsc=esign(hsp,1)
	
} else {
	node_path_movement();
}

if collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey,oDeactivationRegion,false,false) && !on_screen(sprite_width,sprite_height) {
	instance_destroy();
}