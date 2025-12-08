prevx = x;
prevy = y;
x = camera_get_view_x(view_camera[0])
y = camera_get_view_y(view_camera[0])

if (x != prevx) { //check only if its moved to prevent needless updates to layers that may be very cost-heavy
	var i=0;
	repeat(array_length(bglayers)) {
		var _layer = bglayers[i];
		if !(_layer.attach_x) {
			var _x = layer_get_x(_layer.my_layer)
			var x_diff = x-prevx
			layer_x(_layer.my_layer,_x-x_diff/(1+_layer.parallax_x))
		} else {
			layer_x(_layer.my_layer,x+_layer.off_x)
		}
		i++;
	}
}

if (y != prevy) { //check only if its moved to prevent needless updates to layers that may be very cost-heavy
	var i=0;
	repeat(array_length(bglayers)) {
		var _layer = bglayers[i];
		if !(_layer.attach_y) {
			var _y = layer_get_y(_layer.my_layer)
			var y_diff = y-prevy
			layer_y(_layer.my_layer,_y-y_diff/(1+_layer.parallax_y))
		} else {
			layer_y(_layer.my_layer,y+_layer.off_y-(room_height-RESOLUTION_Y))
		}
		i++;
	}
}