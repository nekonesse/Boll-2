//left wall stop
if check_collision_dot(bbox_left - 1,y,COL_WALL) and hsp < 0{
		hsp = 0
		if grounded {
			gsp = 0	
		}
	}
	
//right wall stop
if check_collision_dot(bbox_right + 1,y,COL_WALL) and hsp > 0{
		hsp = 0
		if grounded {
			gsp = 0	
		}
	}




