if !dead && !no_step {
	txr_exec(global.scripts[? $"{charmName}_step_end"]);
}

/// @description poly collision hell
player_poly_collision();

with(oCollider) {
	if (x_diff!=0 || y_diff!=0) {
		with(other) {
			var coll=collision_line(x-hit_sizex+other.x_diff,y+hit_sizey+2+abs(other.y_diff),x+hit_sizex+other.x_diff,y+hit_sizey+2+abs(other.y_diff),other,false,true)
			if (grounded) && (coll) {
				x += coll.x_diff;
				y += coll.y_diff;
			}
		}
	}
}