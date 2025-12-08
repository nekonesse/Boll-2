prevx = x;
prevy = y;
x = camera_get_view_x(view_camera[0])
y = camera_get_view_y(view_camera[0])

if (x != prevx) { //check only if its moved to prevent needless updates to layers that may be very cost-heavy
	var i=0;
	repeat(array_length(bglayers)) {
		var _layer = bglayers[i];
		if !(_layer.attach_x) {
			layer_x(_layer.my_layer,x/(1+(_layer.parallax_x/10))+_layer.off_x)
		} /*else {
			layer_x(_layer.my_layer,x+_layer.off_x)
		}*/
		i++;
	}
}

if (y != prevy) { //check only if its moved to prevent needless updates to layers that may be very cost-heavy
	var i=0;
	repeat(array_length(bglayers)) {
		var _layer = bglayers[i];
		if !(_layer.attach_y) {
			layer_y(_layer.my_layer,y/(1+(_layer.parallax_y/10))+(_layer.off_y-room_height+RESOLUTION_Y))
		} /*else {
			layer_y(_layer.my_layer,y+_layer.off_y-(room_height-RESOLUTION_Y))
		}*/
		i++;
	}
}