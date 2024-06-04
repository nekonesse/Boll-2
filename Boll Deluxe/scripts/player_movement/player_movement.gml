// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function player_movement(){
	
	if (!no_move) {
		move = (right - left);
	} else {
		move = 0
	}
	
	if (move != 0) 
	{	
		//dont walk up a slope if its too steep to walk on!
		
		if grounded {
			var signmatch = check_signs_matching(gsp, move);
			var accel_real = ((signmatch) ? accel : fastaccel);
			gsp += (move * accel_real);
		}else {
			var signmatch = check_signs_matching(hsp, move);
			var accel_real = ((signmatch) ? accel : fastaccel);
			hsp += (move * accel_real);
		}
		
	}
	else
	{
		move=0 //just in case
		// chearii: mhomentunmnm
		if (grounded) {
		
			if (sign(gsp) = -1){
				gsp = min(0, gsp + fric)
			}else{
				gsp = max(0, gsp - fric)
			}
		}
	}
	
	if (abs(gsp) > maxspd) && (grounded) gsp=approach_val(gsp,maxspd,0.5) 
	if (abs(hsp) > maxspd) && (!grounded) hsp=approach_val(hsp,maxspd,0.5) 
	
	if grounded {
		vsp = gsp * -dsin(colangle)
		hsp = gsp * dcos(colangle)
	}
	
	x += hsp 
	y += vsp
	
	player_warping();
}