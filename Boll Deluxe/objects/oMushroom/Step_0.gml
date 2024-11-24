if !is_array(pathing) {
	if (going!=0) {
		image_index=0
		y+=0.33*(going)
		if !place_meeting(x,y-1*going,parentblock) {
			going=0
			hsp = 0.75*((nearestplayer().x > x) ? -1 : 1);
		}
	}

	if (going!=0) exit;

	if !grounded {
		vsp += grav
	} else {
		vsp = 0	
	}

	x += hsp;
	y += vsp;

	player_collision()

	if hsp != 0 xsc=-esign(hsp,-1)
} else {
	node_path_movement();
}

if (place_meeting(x,y,oPlayer)) {
	oPlayer.sig.Emit("mushroom")
	instance_destroy();
}