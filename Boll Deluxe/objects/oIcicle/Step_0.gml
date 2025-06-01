if (can_fall) {
	if !(fallgo) && check_rectangle_in_hitbox(x-4,y-4,x+20,y+255,oPlayer) {
		fallgo = true;
		alarm[0]=7;
	}

	if (fall) {
		vsp=approach_val(vsp,4,0.1);
	}
	y+=vsp

	y_diff = y-yprevious;
	x_diff = x-xprevious;

	if (fall) {
		with(oPlayer) {
			var platform=collision_rectangle(x-hit_sizex+other.x_diff,y-hit_sizey+abs(other.y_diff),x+hit_sizex+other.x_diff,y+hit_sizey+2+abs(other.y_diff),other,false,true)
			if (platform) && (grounded) {
				x += other.x_diff;
				y += other.y_diff;
			}
		}
	
		if check_collision_line(bbox_left,bbox_bottom-1,bbox_right-1,bbox_bottom-1,COL_BOTTOM,oCollider) {
			instance_destroy();
		}
	}
}