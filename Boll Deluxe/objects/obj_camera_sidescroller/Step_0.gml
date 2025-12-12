//makes the camera look ahead in the direction the player is going
if (cam1.bounds_dist_w != 0) {
	if (!lookahead) {
		cam1.offset(60 * sign(cam1.bounds_dist_w), 0, room_speed * 0.5);
		lookahead = true;
	}
} else {
	lookahead = false;
}
