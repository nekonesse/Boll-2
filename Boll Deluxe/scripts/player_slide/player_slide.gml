// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function player_slide() {
	
	if (steep_slope) {
		hsp += 0.1 * colslope
		slopesliding = 1;
	} else if (down && ceil(abs(colslope))) {
		slopesliding = 1;
	}
	
	if (slopesliding) {
		hsp += 0.075*esign(colslope, 1) + (0.075 * colslope)
		crouch=1
		move=0
	}
	
}