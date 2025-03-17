function post_wall(){
	//left wall stop
	if check_collision_line(x - hit_sizex - 1,y - (hit_sizey-2),x - hit_sizex - 1,y + (hit_sizey-2),COL_WALL) and hsp < 0.000{
		var oldhsp = hsp;
		
		hsp = 0
		if grounded {
			gsp = 0	
		}
		
		if (oldhsp != 0) {
			sig.Emit("wall_hit")
		}
	}
	
	//right wall stop
	if check_collision_line(x + hit_sizex + 1,y - (hit_sizey-2),x + hit_sizex + 1,y + (hit_sizey-2),COL_WALL) and hsp > 0.000{
		var oldhsp = hsp;
		
		hsp = 0
		if grounded {
			gsp = 0	
		}
		
		if (object_index==oPlayer) && (oldhsp != 0) {
			sig.Emit("wall_hit")
		}
	}
}