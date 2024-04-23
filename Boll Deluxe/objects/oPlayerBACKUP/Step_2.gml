/// @description Insert description here
// You can write your code in this editor

//left wall stop
if check_collision_dot(bbox_left - 1,y,COL_WALL) and hsp < 0{
		hsp = 0
	}
	
//right wall stop
if check_collision_dot(bbox_right + 1,y,COL_WALL) and hsp > 0{
		hsp = 0
	}




