// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

//#macro COL oCollider

function player_collision(){
	
	
		//left wall
		if sign(hsp) = -1 {
		    while check_collision_dot(bbox_left, y, COL_WALL){
				x++
				//updateBox.Emit()
			}
		} else {
		//right wall
			while check_collision_dot(bbox_right, y, COL_WALL){
				x--
				//updateBox.Emit()
			}
		}
	
	
	//landing on solid ground
	if !grounded && vsp >= 0 {
		if check_collision_line(bbox_left,bbox_bottom,bbox_right,bbox_bottom, COL_BOTTOM){
			grounded = true
			gsp = hsp
			bonk = 0
			//vsp = 0
		}
	}
	
	//hitting the ceiling
	if !grounded && vsp < 0 {
		if (check_collision_dot(bbox_right, bbox_top, COL_TOP)
			or check_collision_dot(bbox_left, bbox_top, COL_TOP)){
			//push out
				
			while (check_collision_dot(bbox_right, bbox_top, COL_TOP) 
				or check_collision_dot(bbox_left, bbox_top, COL_TOP)) {
				y++
				//updateBox.Emit()
			}
				
			vsp = 2
			
			//bonking
			bonk=12
			VinylPlay(snd_blockbump)
		}
	}
	
	
	//normal ground loop (for a variety of slopes
	if grounded {
		
		var offsetx, offsety;
		
		offsetx = xprevious - x
		offsety = yprevious - y
		
		//fall
		if (!check_collision_line(bbox_left,bbox_bottom,bbox_left,bbox_bottom + 16 , COL_BOTTOM) 
			and !check_collision_line(bbox_right,bbox_bottom,bbox_right,bbox_bottom + 16, COL_BOTTOM) ){
				vsp = gsp * -dsin(colangle)
				hsp = gsp * dcos(colangle)
				grounded = false
				return;
			}
			
	}
		
		
	if grounded {
		//move down
		
		    while (!check_collision_line(bbox_left,bbox_bottom,bbox_right,bbox_bottom, COL_BOTTOM)){
				//&& !check_collision_dot(bbox_left,bbox_bottom, COL_BOTTOM)) 
				
				y++
				//updateBox.Emit()
			}
		
		
		//move up
	
		    while (check_collision_line(bbox_left,bbox_bottom,bbox_right,bbox_bottom, COL_BOTTOM)){
				//|| check_collision_dot(bbox_left,bbox_bottom, COL_BOTTOM)) 
				y--
				//updateBox.Emit()
			}
		
	}
	
	//ds_list_destroy(mycollisions)
	bonk=max(bonk,bonk-1)
}