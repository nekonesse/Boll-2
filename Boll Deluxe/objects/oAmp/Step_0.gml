node_path_movement();

if (fallen) {
	vsp = min(3,vsp+grav);
	y += vsp;
}