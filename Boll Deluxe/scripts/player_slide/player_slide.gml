// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function player_slide(max_speed, slide_influence, steep_influence, do_steep_while_slide) {
	
	if (steep_slope) {
		if (!do_steep_while_slide && slopesliding) {
			//dont do it lol
		} else if (do_steep_while_slide && slopesliding) || !slopesliding {
			hsp -= steep_influence * dsin(colangle)	
		}
		//slopesliding = 1;
	} else if (down && ceil(abs(colslope))) {
		slopesliding = 1;
	}
	
	if (slopesliding) {
		hsp -= slide_influence* dsin(colangle)
		crouch=1
		no_move = 1;
		maxspd = max_speed;
	}
	
}