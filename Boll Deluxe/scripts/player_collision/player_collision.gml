// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

//#macro COL oCollider

function player_collision(){
	
	for (var i = 0; i < 16; ++i) {
		//left wall
	    if check_collision_dot(bbox_left, y, COL_WALL){
			x++
		}else{
			break;
		}
		
	}
	
	for (var i = 0; i < 16; ++i) {	
		//right wall
		if check_collision_dot(bbox_right, y, COL_WALL){
			x--
		}else{
			break;
		}
	}
	
	
	//landing on solid ground
	if !grounded && vsp >= 0 {
		if (check_collision_dot(bbox_right, bbox_bottom, COL_BOTTOM) 
			or check_collision_dot(bbox_left, bbox_bottom, COL_BOTTOM) ){
			grounded = true
			vsp = 0
		}

	}
	
	//hitting the ceiling
	if !grounded && vsp < 0 {
		if (check_collision_dot(bbox_right, bbox_top, COL_TOP)
			or check_collision_dot(bbox_left, bbox_top, COL_TOP)){
				//push out
				for (var i = 0; i < 16; ++i) {
			    if (check_collision_dot(bbox_right, bbox_top, COL_TOP) 
					or check_collision_dot(bbox_left, bbox_top, COL_TOP)) {
					y++
				}else{
					break;
				}
				
				vsp = 0
			}
		}
	}
	
	//normal ground loop (for a variety of slopes
	if grounded {
		
		//fall
		if (!check_collision_line(bbox_left,bbox_bottom,bbox_left,bbox_bottom + 16, COL_BOTTOM) 
			and !check_collision_line(bbox_right,bbox_bottom,bbox_right,bbox_bottom + 16, COL_BOTTOM) ){
				grounded = false
				return;
			}
		
		
		//move down
		for (var i = 0; i < 16; ++i) {
		    if (!check_collision_dot(bbox_right,bbox_bottom, COL_BOTTOM)
				&& !check_collision_dot(bbox_left,bbox_bottom, COL_BOTTOM)) {
				y++
			}else{
				break;	
			}
		}
		
		//move up
		for (var i = 0; i < 16; ++i) {
		    if (check_collision_dot(bbox_right,bbox_bottom, COL_BOTTOM)
				|| check_collision_dot(bbox_left,bbox_bottom, COL_BOTTOM)) {
				y--
			}else{
				break;	
			}
		}
		
	}
	
	//ds_list_destroy(mycollisions)
	
}