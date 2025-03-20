// Inherit the parent event
event_inherited();

linelength=0;
laserlength=0;
var loopcount=0;
while !check_collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y-hit_sizey-linelength,COL_TOP) {
	linelength+=16
	loopcount++;
	if loopcount > 50 {
		linelength=0;
		break;
	}
	if check_collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y-hit_sizey-linelength,COL_TOP)
	break;
}

loopcount=0;
while !check_collision_rectangle(x-hit_sizex,y+hit_sizey,x+hit_sizex,y+hit_sizey+maxlaserlength,COL_BOTTOM) {
	maxlaserlength+=16
	loopcount++;
	if loopcount > 50 {
		laserlength=0;
		break;
	}
	
	if check_collision_rectangle(x-hit_sizex,y+hit_sizey,x+hit_sizex,y+hit_sizey+maxlaserlength,COL_BOTTOM)
	break;
}

light_timer=120+timer_offset