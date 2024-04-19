// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

#macro COL_TOP 1
#macro COL_WALL 2
#macro COL_BOTTOM 3


#macro COL_DOT 1
#macro COL_LINE 2

function check_collision_dot(x1, y1, type = 0, object = oCollider){
	
	x1 = round(x1)
	y1 = round(y1)
	
	var found = noone
	found =	collision_point(x1 ,y1,object,true,true)	
	
	//the nefarious
	if found != noone{
		if found.no_collide { 
			found = noone
			return found
		}
	}
	
	if found != noone{
		switch type {
			case 0:
				//awesome
			break;
			case COL_BOTTOM:
				if found.slope { 
					colslope = found.slope_factor * (-1 + (found.hflip* 2))
				}else{
					colslope = 0
				}
			break;
			case COL_WALL:
				if found.semi { found = noone}
			break;
			case COL_TOP:
				if found.semi { found = noone}
			break;
		}
	}
	
	return found
}

function check_collision_line(x1, y1, x2, y2, type = 0, object = oCollider){
	
	x1 = round(x1)
	x2 = round(x2)
	y1 = round(y1)
	y2 = round(y2)
	
	var found = noone
	found =	collision_line(x1,y1,x2,y2,object,true,true)	
	
	//the nefarious
	if found != noone{
		if found.no_collide { 
			found = noone
			return found
		}
	}
	
	if found != noone{
		switch type {
			case 0:
				//awesome
			break;
			case COL_BOTTOM:
				//awesome
			break;
			case COL_WALL:
				if found.semi { found = noone}
			break;
			case COL_TOP:
				if found.semi { found = noone}
			break;
		}
	}
	
	return found
}