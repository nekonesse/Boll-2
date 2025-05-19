x = camera_get_view_x(view_camera[0])
y = camera_get_view_y(view_camera[0])

if (x != xprevious) { //check only if its moved to prevent needless updates to layers that may be very cost-heavy
	xdiff = x / (room_width - RESOLUTION_X);
	layer_x(sky_layer,0)
	layer_x(clouds_layer,floor(x/2))
	layer_x(hills_layer,floor(x/4))
	layer_x(hills2_layer,floor(x/8))
}

if (y != yprevious) { //same thing applies here
	ydiff = y / (room_height - RESOLUTION_Y);
	layer_y(sky_layer,y)
	layer_y(clouds_layer,y+54)
	layer_y(hills_layer,room_height-120)
	layer_y(hills2_layer,room_height-80)
}