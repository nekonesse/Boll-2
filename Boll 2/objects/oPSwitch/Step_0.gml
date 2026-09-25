if !(is_array(pathing) && array_length(pathing)) {
	if (going!=0) {
		image_index=0
		y+=0.33*(going)
		if instance_exists(parentblock) {
			x+=parentblock.x_diff
			y+=parentblock.y_diff
			depth=oGameManager.piping_object_depth[myregion]
			if !collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey,parentblock,false,false) {
				going=0
				depth=2;
			}
		}
	}
}
