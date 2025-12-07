function player_slide(max_speed, slide_influence, steep_influence, do_steep_while_slide) {
	static slope_timer = 0
	if (steep_slope) {
		if !slopesliding {
			//Only make this happen if you're going against the slope.
			
			if !(colangle>=90 && colslope<0) && !(colangle<=90 && colslope>0){			
				gsp -= (steep_influence * dsin(colangle))
				no_move = 1
			}
		}
		//slopesliding = 1;
	} else if (down && ceil(abs(colslope))) {
		slopesliding = 1;
	}
	
	if (slopesliding) {
		gsp -= (slide_influence * dsin(colangle))
		crouch=1
		no_move = 1;
		maxspd = max_speed;
		
		if (abs(hsp) < 0.05) {
			slopesliding = 0;
			crouch = false
			if (!check_collision_line(x-hit_sizex,y-hit_sizey-8,x+hit_sizex,y-hit_sizey-8,COL_TOP) || size=="basic") {
				crouch = false
			} else crouch = true
			no_move = 0;
		}
	}
}